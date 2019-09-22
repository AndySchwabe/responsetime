package main

import (
	"context"
	"fmt"
	"github.com/AndySchwabe/responsetime_go/http"
	"github.com/aws/aws-lambda-go/lambda"
	"time"
)

type MyEvent struct {
	Name string `json:"name"`
}

func HandleRequest(ctx context.Context, name MyEvent) (string, error) {

	start := time.Now()
	status := http.GetStatusCode()
	end := time.Now()
	result := http.ValidateStatusCode(status)

	elapsed := end.Sub(start)

	fmt.Println(elapsed)
	return fmt.Sprintf("Hello %s!", name.Name), nil
}

func main() {
	lambda.Start(HandleRequest)
}
