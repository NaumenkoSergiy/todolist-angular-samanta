if window.location.hash and window.location.hash == '#_=_'
  window.location.hash = ''
  history.pushState('', document.title, window.location.pathname)

app = angular.module 'app', ['angular-loading-bar', 'ui.sortable', 'elastic'
  , 'ui.bootstrap.datetimepicker', 'ngResource', 'ngFileUpload']

app.config ['$httpProvider', ($httpProvider) ->
  token = $('meta[name=csrf-token]').attr 'content'

  $httpProvider.defaults.headers.common['X-CSRF-Token'] = token
]

app.config ['cfpLoadingBarProvider', (cfpLoadingBarProvider) ->
  cfpLoadingBarProvider.includeSpinner = false
  cfpLoadingBarProvider.latencyThreshold = 500
]
