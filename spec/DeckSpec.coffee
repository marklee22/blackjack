describe 'deck', ->
  deck = null
  hand = null

  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()

  describe 'hit', ->
    it "should give the last card from the deck", ->
      expect(deck.length).toBe 50
      expect(deck.last()).toEqual hand.hit()
      expect(deck.length).toBe 49

  describe "discard pile", ->
    
    it "gets all contents of playerHand on new Round", ->

    it "gets all contents of dealerHand on new Round", ->

    it "does not get any additional cards on new Round", ->

    it "preserves its contents on consecutive new Rounds", ->
