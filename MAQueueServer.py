import threading
import time
import random


from http.server import HTTPServer, BaseHTTPRequestHandler
#pip install mysql-connector-python
import mysql.connector


# The RoomKey(need for VidyoRoom launching) and SECONDS are inserted a QElement Object.
class QElement(object):
    def __init__(self,element, priority):
      self.element = element
      self.priority = priority


# This Queue is modification of regular queue. This keeps the longer waiting calls in Patients will be First Out.
# The longest waiting Patients will be pickup up by the Robotic process http request
class PriorityQueue(object):
    def __init__(self):
        self.queue = []
 
    def __str__(self):
        return ' '.join([str(i) for i in self.queue])

    
    # for checking if the queue is empty
    def isEmpty(self):
        return len(self.queue) == 0

    # for inserting an element in the queue
    def insert(self,element,priority):
        qElement = QElement(element, priority);
        self.queue.append(qElement)

    # for popping an element based on Priority
    def delete(self):
        try:
            max = 0
            for i in range(len(self.queue)):
                if self.queue[i].priority > self.queue[max].priority:
                    max = i
            item = self.queue[max]
            del self.queue[max]
            return item
        except IndexError:
            print()
            exit()     

myQueue = PriorityQueue()   

query = ("SELECT C2.CallerName, R.roomID ,R.roomKey, TIMESTAMPDIFF(SECOND,C2.JoinTime,NOW()) AS SECONDS FROM ConferenceCall2 C2 "
"INNER JOIN Conferences C  ON  C.conferenceName = C2.ConferenceName "
"INNER JOIN Room R ON R.roomID = C.roomID "
"WHERE C2.UniqueCallID IN (SELECT UniqueCallID FROM ConferenceCall2  WHERE LeaveTime IS NULL GROUP BY UniqueCallID HAVING COUNT(*) = 1 "
") AND C2.CallState = \'In Progress\' AND C2.TenantName = \'vidyoteleStroke\' AND TIMESTAMPDIFF(MINUTE,C2.JoinTime,NOW()) > 2 ")


    
class ProducerThread(threading.Thread):
    def __init__(self, group=None, target=None, name=None,
                 args=(), kwargs=None, verbose=None):
        super(ProducerThread,self).__init__()
        self.target = target
        self.name = name

    def run(self):
        while True:
            if myQueue.isEmpty():
                    print("Entered Producer Stread")
                    mydb = mysql.connector.connect(
                      host="vidyoportal.med.utah.edu",
                      user="utahdbaccess",
                      password="R3@donly@ccess!",
                      database="portal2",
                      port=3306
                    )

                    mycursor = mydb.cursor()
                    mycursor.execute(query)
                    myresult = mycursor.fetchall()
                    print("Before Result Iteration")
                    for row in myresult:
                        print(row[2])
                        myQueue.insert(row[2],row[3])

                    mycursor.close()
                    mydb.close()
                    #myQueue.insert("O1232Qeee",123)
                    #myQueue.insert("ABCDE",500)
                    #myQueue.insert("Qe1Cthj",250)
                    #myQueue.insert("FcjuTYR",223)
                    #myQueue.insert("Qe1Ctggk",99)

                    print("Producer Stread Waiting 2 minutes");
                    time.sleep(300)
                    
        return



class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        if not myQueue.isEmpty():
         item = myQueue.delete()
         print(item.element)
         self.wfile.write(item.element.encode())
        else:
         print("Query Empty!!")   
         self.wfile.write("EMPTYQUEUE".encode())   





p = ProducerThread(name='producer')
p.start()

print("VidyoRoom Queue Server listening on port 8000")
httpd = HTTPServer(('localhost', 8000), SimpleHTTPRequestHandler)

httpd.serve_forever()


