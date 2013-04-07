describe "App behavior", (app) ->

  beforeEach ->
    spyOn(App.prototype, 'dealerStart').andCallThrough()
    app = new App()

  describe "player stand event", ->

    it "catches the endTurn trigger from player hand", ->
      console.log(3)
      app.get('playerHand').stand()
      console.log(app.get('playerHand'))
      # app.get('playerHand').trigger('endTurn')
      # app.dealerStart()
      expect(app.dealerStart).toHaveBeenCalled()
