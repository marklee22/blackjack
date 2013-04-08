class window.Card extends Backbone.Model

  initialize: (params) ->
    @set
      revealed: true
      value: if !params.rank or 10 < params.rank then 10 else params.rank
      suitName: ['Diamonds', 'Clubs', 'Hearts', 'Spades'][params.suit]
      rankName: switch params.rank
        when 0 then 'King'
        when 1 then 'Ace'
        when 11 then 'Jack'
        when 12 then 'Queen'
        else params.rank
    @makeBackground params.suit, params.rank

  flip: ->
    @set 'revealed', !@get 'revealed'
    @

  makeBackground: (suit, rank) ->
    offsetTop = 46
    offsetLeft = 79
    gapHor = 8.4
    gapVer = 10.75
    length = 124
    height = 175

    cardid = switch
      when rank is 0 then 11
      when rank is 1 then 12
      else rank - 2

    @set 'top', offsetTop + (suit * gapVer) + (suit * height)
    @set 'left', offsetLeft + (cardid * gapHor) + (cardid * length)

