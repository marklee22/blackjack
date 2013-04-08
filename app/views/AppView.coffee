class window.AppView extends Backbone.View

  template: _.template '
  <div class="main"><div class="container">
    <% if(!isDealerTurn && !isGameOver) { %> 
      <button class="hit-button btn btn-danger">Hit</button> <button class="stand-button btn btn-success">Stand</button>
    <% } %>
    <% if(isGameOver) { %>
      <button class="new-round-button btn btn-info">New Round</button>
      <div class="label-important status animated fadeIn">You <%= status %>!</div>
    <% } %>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  </div></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "click .new-round-button": -> @model.newRound()

  initialize: ->
    @render()
    @model.on 'change:isDealerTurn', ->
      @render()
    , @
    @model.on 'change:isGameOver', ->
      @render()
    , @
    @model.on 'change:status', ->
      @render()
    , @

  render: ->
    @$el.children().detach()
    @$el.html @template(@model.attributes)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
