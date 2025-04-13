document.addEventListener('DOMContentLoaded', () => {
    // reference to the url input, library select, and the submit button
    const urlInput = document.getElementById('urlInput');
    const librarySelect = document.getElementById('librarySelect'); // added reference to library select
    const submitBtn = document.getElementById('submitBtn');

    // function to check the validity of the url
    function isValidPlexURL(url) {
      return url.startsWith('https://watch.plex.tv/');
    }

    // function to handle the submission
    function handleSubmit() {
      // retrieve the url from the input
      const url = urlInput.value;
      // retrieve the selected library from the dropdown
      const library = librarySelect.value;

      // check if a library is selected
      if (!library) {
        alert('Please select a library.');
        return; // stop the function if no library is selected
      }

      // check if the url is a valid plex url
      if (isValidPlexURL(url)) {
        // send the url and library to the server for processing
        fetch('/process-url', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          // include the library in the data sent to the server
          body: JSON.stringify({ url, library })
        })
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(data => {
          // log the extracted data to the console
          console.log('Extracted Data:', data);
          // TODO: add a preview of what's going to be sent here
        })
        .catch(error => {
          console.error('Error:', error);
        });
      } else {
        // alert the user if the url is not a valid plex url
        alert('Please enter a valid Plex URL.');
      }
    }

    // add event listener for the submit button click
    submitBtn.addEventListener('click', (event) => {
      event.preventDefault(); // prevent default form submission on click
      handleSubmit();
    });

    // add event listener to allow the Enter key to also trigger the submission
    urlInput.addEventListener('keypress', (event) => {
      if (event.key === 'Enter') {
        event.preventDefault(); // prevent default form submission on Enter key
        handleSubmit();
      }
    });
});
