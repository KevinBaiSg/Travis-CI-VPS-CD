package main

import "github.com/gin-gonic/gin"


func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong v:0.0.1",
		})
	})
	if err := r.Run(); err != nil {
		return
	}
}
