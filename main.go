package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi"
	"github.com/gomodule/redigo/redis"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// injected during build
var keyspace = "demo:requests"

// initCachePool initializes redis for cache
func initCachePool(addr string) *redis.Pool {
	return &redis.Pool{
		MaxIdle:     3,
		IdleTimeout: 300 * time.Second,
		Dial: func() (redis.Conn, error) {
			c, err := redis.Dial("tcp", addr)
			if err != nil {
				return nil, err
			}
			return c, nil
		},
	}
}

func main() {
    go func(){
        http.Handle("/metrics", promhttp.Handler())
        http.ListenAndServe(":2112", nil)
    }()
	// init redis
	cachePool := initCachePool(os.Getenv("DEMO_REDIS_ADDR"))

	// check if redis is alive or not
	conn := cachePool.Get()
	defer conn.Close()
	_, err := conn.Do("PING")
	if err != nil {
		panic(fmt.Sprintf("error initializing cache pool: %v", err))
	}

	// initialise handlers
	r := chi.NewRouter()
	r.Get("/", func(w http.ResponseWriter, _ *http.Request) {
		err = incrementKey(conn)
		if err != nil {
			fmt.Fprintf(w, "oops something went wrong: %v", err)
			return
		}
		val, err := redis.Int(conn.Do("GET", keyspace))
		if err != nil {
			fmt.Fprintf(w, "oops something went wrong: %v", err)
			return
		}
		fmt.Fprintf(w, "welcome to api. key count is: %d", val)
	})
	addr := os.Getenv("DEMO_APP_ADDR")
	if addr == "" {
		addr = ":8080"
	}
	log.Printf("Booting app on %s", addr)
	http.ListenAndServe(addr, r)
}

func incrementKey(c redis.Conn) error {
	c.Send("INCR", keyspace)
	err := c.Flush()
	if err != nil {
		return err
	}
	return nil
}
