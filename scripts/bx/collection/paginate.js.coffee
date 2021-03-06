class Bx.Collection.Paginate extends Bx.Collection.Base

  constructor: (models, options = {}) ->
    super(models, options)
    @pageSize = options.pageSize ? 10
    @pageCurrent = options.pageCurrent ? 0
    @pageTotal = options.pageTotal ? 1

  parse: (response) ->
    @pageCurrent = if response.pagination then response.pagination.pageCurrent ? 1 else 1
    @pageTotal = if response.pagination then response.pagination.pageTotal ? 1 else 1
    @itemCount = if response.pagination then response.pagination.itemCount ? 0 else 0
    response.items || []

  fetch: (options = {}) ->
    options.data =  $.extend(options.data || {}, {page: @pageCurrent, pageSize: @pageSize})
    super(options)

# RESTART THE SEARCH
  restart: (options = {}) ->
    options.reset = true
    @pageCurrent = 1
    @fetch(options)

  goto: (page, options = {}) ->
    options.reset = true
    @pageCurrent = page
    @fetch(options)

# PREV PAGE / NEXT PAGE
  prev: (options = {}) ->
    options.reset = true
    if @pageCurrent > 0
      @pageCurrent--
      @fetch(options)

  hasPrev: () ->
    @pageCurrent > 1

  next: (options = {}) ->
    options.reset = true
    if @pageCurrent < @pageTotal
      @pageCurrent++
      @fetch(options)

  hasNext: () ->
    @pageCurrent < @pageTotal

# MORE PAGE
  more: (options = {}) ->
    options.reset = false
    if @pageCurrent < @pageTotal
      @pageCurrent++
      @fetch(options)

  hasMore: () ->
    @pageCurrent < @pageTotal
