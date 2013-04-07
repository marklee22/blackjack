#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'isDealerTurn', false
    @set 'gameOver', false
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer() 
    @get('playerHand').on 'lose', (hand) -> 
      console.log(' ')
    , this
    # @get('dealerHand').on 'lose', @gameOver, this
    @get('playerHand').on 'blackjack', @blackJack, this
    @get('playerHand').on 'endTurn', @dealerStart, this
    @get('dealerHand').on 'endTurn', @gameOver, this
    console.log(@get('playerHand'),@get('dealerHand'))

  gameOver: ->
    console.log(@get('playerHand').scores(), @get('dealerHand').scores())

    if(@isDealer)
      console.log('Player won!')
    else
      console.log('Dealer won!')

    @set 'gameOver', true

  blackJack: ->
    console.log('blackjack')

  newRound: ->

  dealerStart: ->
    @set 'isDealerTurn', true
    @get('dealerHand').each (card) ->
      card.set('revealed', true)

    while(score = @get('dealerHand').scores() < 17)
      # TODO: account for dealer busting
      @get('dealerHand').hit()

    @get('dealerHand').stand()

    # console.log 'End dealer turn'