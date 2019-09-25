package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/AndySchwabe/responsetime/http"
	"github.com/aws/aws-lambda-go/lambda"
)

// MyEvent Lambda Event struct
type MyEvent struct {
	Name string `json:"name"`
}

// HandleRequest Lambda Handler
func HandleRequest(ctx context.Context, name MyEvent) (string, error) {

	start := time.Now()
	status := http.GetStatusCode("http://google.com")
	end := time.Now()
	result := http.ValidateStatusCode(status)
	if !result {
		log.Fatalf("Received %d", status)
	}
	elapsed := end.Sub(start)

	fmt.Println(elapsed)
	return fmt.Sprintf("Hello %s!", name.Name), nil
}

func main() {
	lambda.Start(HandleRequest)
}
