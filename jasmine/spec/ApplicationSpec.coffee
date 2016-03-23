describe 'Application', ->
  beforeEach ->
    @.app = new Application()
    setFixtures fixtures

  it 'testable, its templates loadable, its AJAX calls mockable!', ->
    spyOn($, 'getJSON').and.callFake (r) ->
      d = $.Deferred()
      d.resolve requests.users
      d.promise()
    doneFn = jasmine.createSpy 'done'
    $.when(@.app.init()).done (data) ->
      doneFn data
    expect(doneFn).toHaveBeenCalled()
    expect($('#work-space tbody#users-list tr td')[0]).toBeInDOM()
    expect($('#work-space tbody#users-list tr').length).toEqual 4
