package main
 
import (
    "net/http"
    "bytes"
    "fmt"
    "log"
    "os/exec"
)
 

func system(s string) {
	cmd := exec.Command("/bin/sh", "-c", s) 
	var out bytes.Buffer 

	cmd.Stdout = &out 
	err := cmd.Run() 
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%s", out.String())
}

func deployJekyll(w http.ResponseWriter, r *http.Request) {
	system("/data/wwwroot/tanglei.name/deploy.sh")
	w.Write([]byte("Ok"))
}

func main() {
    // http.Handle("/css/", http.FileServer(http.Dir("template")))
     
    http.HandleFunc("/deploy-jekyll/", deployJekyll)
    http.ListenAndServe(":8888", nil)
 
}
