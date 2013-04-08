class window.CardView extends Backbone.View

  className: 'card'

  template: _.template '' # <%= rankName %> of <%= suitName %>'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    @$el.html @template @model.attributes
    if(@model.get 'revealed')
      @$el.css 
        'background-position-x': '-' + @model.get('left') + 'px'
        'background-position-y': '-' + @model.get('top') + 'px'
    else
      @$el.addClass 'covered'
