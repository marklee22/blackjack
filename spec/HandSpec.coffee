describe "Hand",(hand) ->

  beforeEach ->
    hand = new Hand([new Card({rank:9, suit: 0}), new Card({rank:8, suit:0})], new Deck(), false, new DiscardPile())

  it "triggers 'endTurn' event when player stands", ->
    spyOn(hand, 'trigger').andCallThrough()
    hand.stand()
    expect(hand.trigger).toHaveBeenCalledWith('endTurn', hand)

  it "calls 'checkScore' every time hit is called", ->
    spyOn(hand, 'check').andCallThrough()
    hand.add(new Card({rank:5, suit:0}))
    expect(hand.check).toHaveBeenCalled()

  it "triggers 'lose' event if hand total is greater than 21", ->
    spyOn(hand, 'trigger').andCallThrough()
    expect(hand.scores()).toEqual([17])
    hand.add(new Card({rank:10, suit:0}))
    expect(hand.trigger).toHaveBeenCalledWith('lose', hand)

  it "aces in a hand will not trigger 'lose' event if one possible hand is > 21", ->
    spyOn(hand, 'trigger').andCallThrough()
    hand.add(new Card({rank:1, suit:0}))
    expect(hand.trigger).not.toHaveBeenCalledWith('lose', hand)

  it "a discarded hand moves cards to the discard pile", ->
    hand.discard()
    expect(hand.length).toEqual(0)
    expect(hand.discardPile.length).toEqual(2)

  it "deal moves two new cards from the deck to the hand", ->
    hand.discard()
    hand.deal()
    expect(hand.deck.length).toEqual(50)
    expect(hand.length).toEqual(2)

  describe "with blackjack", ->
    beforeEach ->
      hand = new Hand([new Card({rank:1, suit: 0})], null, false)
      spyOn(hand, 'trigger').andCallThrough()

    it "of Ace 10", ->
      hand.add(new Card({rank:10, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack', hand)
    it "of Ace Jack", ->
      hand.add(new Card({rank:11, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack', hand)
    it "of Ace Queen", ->
      hand.add(new Card({rank:12, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack', hand)
    it "of Ace King", ->
      hand.add(new Card({rank:0, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack', hand)
