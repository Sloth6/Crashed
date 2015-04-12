key = "crashedSavedGames"
window.saveManager =
  loadAll: () ->
    fileString = localStorage.getItem key
    # console.log fileString, filesString?
    if fileString? then JSON.parse(fileString) else []

  save: (name, file) ->
    # console.log 'savng', file
    file.name = name
    file.date = Date.now()
    files = window.saveManager.loadAll()
    files.unshift file
    localStorage.setItem key, JSON.stringify(files)
    # console.log localStorage.getItem key

console.log window.saveManager.loadAll()