# 多线程编程

> 学习董明伟python, 内容来自爱湃森，如有侵权，请提醒下架，谢谢！


```
import threading
import time

def daemon():
  print("Daemon starting")
  time.sleep(0.5)
  print("Daemon Exiting")
  
def no_daemon():
  print("No_Daemon Starting")
  print("No_Daemon Exiting")
  
d = threading.Threads(name="daemon", target=daemon, daemon=True)
t = threading.Threads(name="no_daemon", target=no_daemon, daemon=False)
```

