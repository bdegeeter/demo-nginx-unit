package main

import (
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"strings"
	"unit.nginx.org/go"
)

func formatRequest(r *http.Request) string {

	h := make(map[string]string)
	m := make(map[string]string)
	t := make(map[string]interface{})

	m["message"] = "Unit reporting"
	m["agent"] = "NGINX Unit 1.28.0"

	body, _ := ioutil.ReadAll(r.Body)
	m["body"] = fmt.Sprintf("%s", body)

	m["sha256"] = fmt.Sprintf("%x", sha256.Sum256([]byte(m["body"])))

	data, _ := json.Marshal(m)
	for name, _ := range r.Header {
		h[strings.ToUpper(name)] = r.Header.Get(name)
	}
	_ = json.Unmarshal(data, &t)
	t["headers"] = h

	js, _ := json.MarshalIndent(t, "", "    ")

	return fmt.Sprintf("%s", js)
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		io.WriteString(w, formatRequest(r))
	})
	unit.ListenAndServe(":8080", nil)
}
