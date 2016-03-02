app = angular.module('app')

app.factory 'ProjectResource', ['$resource', ($resource) ->
  $resource '/projects/:id', { id: '@id' }, {
    update: { method: 'PUT' }
  }
]

app.factory 'TaskResource', ['$resource', ($resource) ->
  $resource '/tasks/:id/:action', { id: '@id' }, {
    update:   { method: 'PUT' },
    done:     { params: { action: 'done' }, method: 'PUT' }
    sort:     { params: { action: 'sort' }, method: 'PUT' }
    deadline: { params: { action: 'deadline' }, method: 'PUT' }
  }
]

app.factory 'CommentResource', ['$resource', ($resource) ->
  $resource '/comments/:id', { id: '@id' }
]
