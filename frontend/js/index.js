function checkResponseTime () {
  // const inputURL = document.getElementById('inputURL').value
  const Http = new XMLHttpRequest()
  const url = 'https://jsonplaceholder.typicode.com/posts'
  // const url = 'https://responsetime.net/api'
  Http.open('GET', url)
  Http.send()

  Http.onreadystatechange = (e) => {
    document.getElementById('value').innerHTML = Http.responseText
  }
}
