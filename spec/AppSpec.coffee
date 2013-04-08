describe "App", ->
  app = null

  beforeEach ->
    spyOn(App.prototype, 'dealerStart').andCallThrough()
    spyOn(App.prototype, 'gameOver').andCallThrough()
    spyOn(Hand.prototype, 'trigger').andCallThrough()
    spyOn(App.prototype, 'trigger').andCallThrough()
    app = new App()

  it "listens to player 'endTurn'", ->
    app.get('playerHand').stand()
    expect(app.dealerStart).toHaveBeenCalled()
    expect(app.get('isDealerTurn')).toBe(true)

  it "dealer reveals cards after dealerStart called", ->
    app.dealerStart()
    expect(app.get('dealerHand').every (card) -> card.get('revealed') is true).toBe(true)

  it "listens to dealer 'endTurn'", ->
    app.dealerStart()
    dealerHand = app.get('dealerHand')
    expect(dealerHand.trigger).toHaveBeenCalledWith('endTurn', dealerHand)

  describe "gameOver", ->

    it "is called when dealerHand endTurn is triggered", ->
      app.dealerStart()
      expect(app.gameOver).toHaveBeenCalled()

    it "evaluates the player and dealer hands", ->
      expect(app.get('isGameOver')).toBe(false)
      app.gameOver()
      expect(app.get('isGameOver')).toBe(true)

    it "sets the status for player loss", ->
      app.gameOver(app.get('playerHand'))
      expect(app.get('status')).toEqual('loss')
      expect(app.get('isGameOver')).toBe(true)

    it "sets the status for player win", ->
      app.gameOver(app.get('dealerHand'))
      expect(app.get('status')).toEqual('win')
      expect(app.get('isGameOver')).toBe(true)

    it "sets the status for tie", ->
      app.gameOver()
      expect(app.get('status')).toEqual('tie')
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

    it "called multiple times", ->
      app.newRound()
      app.newRound()
      expect(app.get('discardPile').length).toEqual(8)
      expect(app.get('deck').length).toEqual(40)

    xit "sets isDealer turn to false", ->

    xit "sets gameOver to false", ->

    xit "preserves the same deck for the new game", ->

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

    it "does weird shit with aces", ->
      # TODO

