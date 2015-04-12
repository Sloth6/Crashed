key = "crashedSavedGames"
window.saveManager =
  loadAll: () ->
    fileString = localStorage.getItem key
    # console.log fileString, filesString?
    if fileString? then JSON.parse(fileString) else []

  save: (file) ->
    console.log 'savng', file
    files = window.saveManager.loadAll()
    files.push file
    localStorage.setItem key, JSON.stringify(files)
    # console.log localStorage.getItem key

console.log window.saveManager.loadAll()