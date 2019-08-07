package Travis_CI_VPS_CD

import "github.com/gin-gonic/gin"


func Main() {
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
