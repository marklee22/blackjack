describe "App behavior", (app) ->

  beforeEach ->
    spyOn(App.prototype, 'dealerStart').andCallThrough()
    app = new App()

  describe "player stand event", ->

    it "catches the endTurn trigger from player hand", ->
      app.get('playerHand').stand()
      expect(app.dealerStart).toHaveBeenCalled()

    it "starts the dealer actions", ->
      app.get('playerHand').stand()

