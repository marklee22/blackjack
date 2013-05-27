describe "App", ->
  app = null

  beforeEach ->
    spyOn(App.prototype, 'dealerStart').andCallThrough()
    spyOn(App.prototype, 'gameOver').andCallThrough()
    spyOn(Hand.prototype, 'trigger').andCallThrough()
    spyOn(App.prototype, 'trigger').andCallThrough()
    app = new App()

  it "listens to player 'endTurn' and gives control to dealer", ->
    app.get('playerHand').stand()
    expect(app.dealerStart).toHaveBeenCalled()
    expect(app.get('isDealerTurn')).toBe(true)

  it "dealer reveals cards after dealerStart called", ->
    app.dealerStart()
    expect(app.get('dealerHand').every (card) -> card.get('revealed') is true).toBe(true)

  it "calls calculateWinner upon dealer ending his turn", ->
    spyOn(app, 'calculateWinner').andCallThrough()
    app.dealerStart()
    expect(app.calculateWinner).toHaveBeenCalled()

  it "sets status to 'win' if player has blackjack", ->
    spyOn(app, 'calculateWinner').andCallThrough()
    app.get('playerHand').trigger('blackjack')
    expect(app.gameOver).toHaveBeenCalledWith(app.get('dealerHand'))

  describe "gameOver", ->

    it "evaluates the player and dealer hands", ->
      expect(app.get('isGameOver')).toBe(false)
      app.gameOver()
      expect(app.get('isGameOver')).toBe(true)

    it "sets the status to 'lost' for player loss", ->
      app.gameOver(app.get('playerHand'))
      expect(app.get('status')).toEqual('lost')
      expect(app.get('isGameOver')).toBe(true)

    it "sets the status to 'won' for player win", ->
      app.gameOver(app.get('dealerHand'))
      expect(app.get('status')).toEqual('won')
      expect(app.get('isGameOver')).toBe(true)

    it "sets the status to 'tie' for tie", ->
      app.gameOver()
      expect(app.get('status')).toEqual('tied')
      expect(app.get('isGameOver')).toBe(true)

  describe "newRound", (oldPlayerHand, oldDealerHand, playerHand, dealerHand) ->

    beforeEach ->
      oldPlayerHand = app.get('playerHand').clone()
      oldDealerHand = app.get('dealerHand').clone()
      playerHand = app.get('playerHand')
      dealerHand = app.get('dealerHand')
      app.gameOver()

    it "discards all cards in play to the discard pile", ->
      expect(app.get('discardPile').length).toEqual(0)
      app.newRound()
      expect(app.get('discardPile').length).toEqual(4)

    it "deals new cards", ->
      app.newRound()
      expect(app.get('playerHand').length).toEqual(2)
      expect(app.get('dealerHand').length).toEqual(2)
      expect(app.get('dealerHand').at(0).get('revealed')).toBe(false)

    it "reuses the same deck and discard pile everytime it's called", ->
      app.newRound()
      app.newRound()
      expect(app.get('discardPile').length).toEqual(8)
      expect(app.get('deck').length).toEqual(40)

    it "resets isDealer and isGameOver flags to false", ->
      app.newRound()
      expect(app.get('isGameOver')).toBe(false)
      expect(app.get('isDealerTurn')).toBe(false)

  describe "dealer AI", ->
    dealer = null

    beforeEach ->
      hand = new Hand([new Card({rank:10, suit: 0}), new Card({rank:2, suit:0})], new Deck(), true)
      app.set('dealerHand', hand)
      dealer = app.get('dealerHand')

    it "hits if below 17", ->
      previousScore = dealer.scores()
      app.dealerStart()
      expect(dealer.scores()).toBeGreaterThan(previousScore)

    it "stands if 17 or higher", ->
      dealer.add(new Card({rank:8, suit:0}))
      previousScore = dealer.scores()
      app.dealerStart()
      expect(dealer.scores()).toEqual(previousScore)

