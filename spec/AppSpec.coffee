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

  it "gameOver is called when dealerHand endTurn is triggered", ->
    app.dealerStart()
    expect(app.gameOver).toHaveBeenCalled()

  it "gameOver evaluates the player and dealer hands", ->
    expect(app.get('gameOver')).toBe(false)
    app.gameOver()
    expect(app.get('gameOver')).toBe(true)

  describe "New rounds on the same deck", (oldPlayerHand, oldDealerHand, playerHand, dealerHand) ->

    beforeEach ->
      oldPlayerHand = app.get('playerHand').clone()
      oldDealerHand = app.get('dealerHand').clone()
      playerHand = app.get('playerHand')
      dealerHand = app.get('dealerHand')
      app.gameOver()



    xit "sets isDealer turn to false", ->

    xit "sets gameOver to false", ->

    xit "preserves the same deck for the new game", ->

  xdescribe "management of discarded cards", ->

    it "playerHand and dealerHand now have different cards", ->
      app.newRound()
      # check discard pile === 4
      # check deck size === 52 - 4 - 4
      # check cards in hand are correct
        # 2 cards each
        # dealer first card isn't revealed
      # check total cards === 52



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

