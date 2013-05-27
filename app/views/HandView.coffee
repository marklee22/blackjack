class window.HandView extends Backbone.View

  className: 'hand animated'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @collection.on 'change', => @render()
    @collection.on 'add', => @render()
    @render()

  render: ->
    @$el.children().detach
    @$el.html(@template @collection).append @collection.map (card, index) ->
      cardView = new CardView(model: card)
      if index < 2 || index < @collection.length - 1
        cardView.$el.removeClass('fadeInLeft')
      else
        cardView.$el.addClass('fadeInLeft')
      cardView.el
    , this
    @$('.score').text @collection.getScoreMessage()