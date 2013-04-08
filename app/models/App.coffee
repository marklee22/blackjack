#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->

    # App variable initialization
    @set 'discardPile', discardPile = new DiscardPile()
    @set 'isDealerTurn', false
    @set 'isGameOver', false
    @set 'status', ''
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer(discardPile)
    @set 'dealerHand', deck.dealDealer(discardPile)

    # Event triggers
    @get('playerHand').on 'lose', @gameOver, this
    @get('dealerHand').on 'lose', @gameOver, this
    @get('playerHand').on 'blackjack', @blackJack, this
    @get('dealerHand').on 'blackjack', @blackJack, this
    @get('playerHand').on 'endTurn', @dealerStart, this
    @get('dealerHand').on 'endTurn', @calculateWinner, this
    @get('deck').on 'runningLow', @reshuffle, this

  calculateWinner: ->
    playerScore = @get('playerHand').getBestScore()
    dealerScore = @get('dealerHand').getBestScore()

    if(playerScore > dealerScore)
      @gameOver(@get('dealerHand'))
    else if(dealerScore > playerScore)
      @gameOver(@get('playerHand'))
    else
      @gameOver()

  reshuffle: (deck) ->
    discardPile = @get('discardPile')
    @get('discardPile').each (card) ->
      deck.add(card)
      card.set 'revealed', true
      discardPile.remove(card)
    @get('deck').shuffle()

  gameOver: (hand) ->
    if(hand is @get('dealerHand'))
      @set 'status', 'won' 
    else if(hand is @get('playerHand'))
      @set 'status', 'lost'
    else
      @set 'status', 'tied'

    @set 'isGameOver', true

  blackJack: ->
    console.log('blackjack')

  newRound: ->
    @get('playerHand').discard()
    @get('dealerHand').discard()

    @get('playerHand').deal()
    @get('dealerHand').deal()

    @set('isDealerTurn', false)
    @set('isGameOver', false)
    @set('status', '')

  dealerStart: ->
    @set 'isDealerTurn', true
    @get('dealerHand').each (card) ->
      card.set('revealed', true)

    while(score = @get('dealerHand').scores() < 17)
      # TODO: account for dealer busting
      @get('dealerHand').hit()

    @get('dealerHand').stand()
