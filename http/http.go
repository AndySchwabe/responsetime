package http

import (
	"log"
	"net/http"
)

// GetStatusCode Makes a request to a passed URL
func GetStatusCode(userURL string) int {
	response, responseErr := http.Get(userURL)
	if responseErr != nil {
		log.Fatal(responseErr)
	}
	closeErr := response.Body.Close()
	if closeErr != nil {
		log.Fatal(closeErr)
	}
	return response.StatusCode
}

// ValidateStatusCode Validates a passed HTTP status code
func ValidateStatusCode(statuscode int) bool {
	if statuscode == 200 {
		return true
	} else {
		return false
	}
}
