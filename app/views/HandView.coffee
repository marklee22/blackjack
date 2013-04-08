class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @collection.on 'change', => @render()
    @collection.on 'add', => @render()
    @render()

  render: ->
    @$el.children().detach
    @$el.html(@template @collection).append @collection.map (card) -> new CardView(model: card).el
    if(@collection.at(0).get('revealed') is true)
      @$('.score').text @collection.getBestScore()
    else if(@collection.scores().length is 2)
      @$('.score').text @collection.scores()[0] + ' or ' + @collection.scores()[1]
    else
      @$('.score').text @collection.scores()[0]