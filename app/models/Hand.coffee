class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer, @discard) ->
    @on 'add', => @check()
    @model

  discard: ->
    # current cards moved to discard
    # @discard.push(@cards.pop())

  hit: ->
    @add(@deck.pop()).last() unless (@scores().every (score) -> score > 21)

  check: ->
    if @length is 2 and @scores()[1] is 21
      @trigger('blackjack')
    else if(@scores().every (score) -> score > 21)
      @trigger('lose', this)

  stand: ->
    @trigger('endTurn', this)

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]