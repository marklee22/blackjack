#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'isDealerTurn', false
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on 'lose', (hand) -> 
      console.log(hand.isDealer)
    , this
    # @get('dealerHand').on 'lose', @gameOver, this
    @get('playerHand').on 'blackjack', @blackJack, this
    @get('playerHand').on 'endTurn', @dealerStart, this

  gameOver: ->
    console.log(@get('playerHand').scores(), @get('dealerHand').scores())

    if(@isDealer)
      console.log('Player won!')
    else
      console.log('Dealer won!')

  blackJack: ->
    console.log('blackjack')

  dealerStart: ->
    console.log('dealer Starting...')
    # @set 'isDealerTurn', true
    console.log('here')