describe "Hand",(hand) ->

  beforeEach ->
    hand = new Hand([new Card({rank:9, suit: 0}), new Card({rank:8, suit:0})], null, false)

  it "triggers 'endTurn' when player 'stands'", ->
    spyOn(hand, 'trigger').andCallThrough()
    hand.stand()
    expect(hand.trigger).toHaveBeenCalledWith('endTurn', hand)

  it "calls checkScore every time you add", ->
    spyOn(hand, 'check').andCallThrough()
    hand.add(new Card({rank:5, suit:0}))
    expect(hand.check).toHaveBeenCalled()

  it "triggers 'lose' event if greater than 21", ->
    spyOn(hand, 'trigger').andCallThrough()
    expect(hand.scores()).toEqual([17])
    hand.add(new Card({rank:10, suit:0}))
    expect(hand.trigger).toHaveBeenCalledWith('lose', hand)

  it "doesn't trigger 'lose' for hands with aces", ->
    spyOn(hand, 'trigger').andCallThrough()
    hand.add(new Card({rank:1, suit:0}))
    expect(hand.trigger).not.toHaveBeenCalledWith('lose', hand)

  describe "with blackjack", ->
    beforeEach ->
      hand = new Hand([new Card({rank:1, suit: 0})], null, false)
      spyOn(hand, 'trigger').andCallThrough()

    it "of Ace 10", ->
      hand.add(new Card({rank:10, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack')
    it "of Ace Jack", ->
      hand.add(new Card({rank:11, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack')
    it "of Ace Queen", ->
      hand.add(new Card({rank:12, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack')
    it "of Ace King", ->
      hand.add(new Card({rank:0, suit:0}))
      expect(hand.trigger).toHaveBeenCalledWith('blackjack')
