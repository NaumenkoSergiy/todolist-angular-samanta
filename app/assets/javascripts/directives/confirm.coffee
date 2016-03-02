angular.module('app').directive 'ngConfirmClick', [ ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.bind 'click', ->
      message = attrs.ngConfirmMessage
      scope.$apply(attrs.ngConfirmClick) if message && confirm(message)
]
