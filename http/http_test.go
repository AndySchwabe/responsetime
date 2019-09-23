package http

import (
	"testing"
)

func TestGetStatusCode(t *testing.T) {
	status := GetStatusCode("http://google.com")
	statuses := []int{100, 101, 102, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 426, 428, 429, 431, 444, 451, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511, 599}

	match := false
	for _, code := range statuses {
		if status == code {
			match = true
		}
	}

	if match != true {
		t.Errorf("Status was not in our slice of statuses, got: %d, wanted one of codes obtained from https://httpstatuses.com/.", status)
	}
}

func TestValidateStatusCode(t *testing.T) {
	tables := []struct {
		code  int
		value bool
	}{
		{100, false},
		{101, false},
		{102, false},
		{200, true},
		{201, false},
		{202, false},
		{203, false},
		{204, false},
		{205, false},
		{206, false},
		{207, false},
		{208, false},
		{226, false},
		{300, false},
		{301, false},
		{302, false},
		{303, false},
		{304, false},
		{305, false},
		{307, false},
		{308, false},
		{400, false},
		{401, false},
		{402, false},
		{403, false},
		{404, false},
		{405, false},
		{406, false},
		{407, false},
		{408, false},
		{409, false},
		{410, false},
		{411, false},
		{412, false},
		{413, false},
		{414, false},
		{415, false},
		{416, false},
		{417, false},
		{418, false},
		{421, false},
		{422, false},
		{423, false},
		{424, false},
		{426, false},
		{428, false},
		{429, false},
		{431, false},
		{444, false},
		{451, false},
		{499, false},
		{500, false},
		{501, false},
		{502, false},
		{503, false},
		{504, false},
		{505, false},
		{506, false},
		{507, false},
		{508, false},
		{510, false},
		{511, false},
		{599, false},
	}
	for _, table := range tables {
		val := ValidateStatusCode(table.code)

		if val != table.value {
			t.Errorf("HTTP Status Code %d was incorrect, got: %t, want: %t.", table.code, val, table.value)
		}
	}
}
