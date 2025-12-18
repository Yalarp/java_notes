# 📚 Java Socket Programming - Complete Guide (TCP/UDP)

## Table of Contents
1. [Introduction to Networking](#introduction-to-networking)
2. [Client-Server Architecture](#client-server-architecture)
3. [TCP vs UDP](#tcp-vs-udp)
4. [Port Numbers](#port-numbers)
5. [TCP Socket Programming](#tcp-socket-programming)
6. [UDP Socket Programming](#udp-socket-programming)
7. [URL and URLConnection](#url-and-urlconnection)
8. [Multi-Client Server](#multi-client-server)
9. [Sending Objects Over Network](#sending-objects-over-network)
10. [Interview Questions](#interview-questions)

---

## 🌐 Introduction to Networking

Java provides robust networking capabilities through the `java.net` package. Socket programming enables communication between applications running on different machines (or same machine on different ports).

### Key Classes in java.net

| Class | Purpose |
|-------|---------|
| `Socket` | Client-side TCP connection |
| `ServerSocket` | Server-side TCP listener |
| `DatagramSocket` | UDP communication |
| `DatagramPacket` | UDP packet container |
| `InetAddress` | IP address representation |
| `URL` | Uniform Resource Locator |
| `URLConnection` | Open connection to URL |

---

## 🖥️ Client-Server Architecture

### Fundamental Concept

```
┌─────────────────────────────────────────────────────────────────────┐
│ Client-Server Communication                                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   CLIENT                              SERVER                        │
│   ┌──────────┐                       ┌──────────┐                  │
│   │          │                       │          │                  │
│   │  Step 2  │       Network         │  Step 1  │                  │
│   │ Connect  │ ─────────────────────►│ Ready &  │                  │
│   │ to Server│                       │ Waiting  │                  │
│   │          │                       │          │                  │
│   └──────────┘                       └──────────┘                  │
│                                                                      │
│   CLIENT must know:                   SERVER must:                  │
│   • Server's IP address               • Be running and ready       │
│   • Port number of application        • Listen on specific port    │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### What is a Port Number?

On a server, multiple applications run simultaneously (Tomcat, Oracle, WebLogic, etc.). **Port numbers** differentiate these applications.

```
┌─────────────────────────────────────────────────────────────────────┐
│ SERVER MACHINE                                                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐  │
│   │  Tomcat Server  │   │  Oracle Server  │   │  WebLogic       │  │
│   │   Port: 8080    │   │   Port: 1521    │   │   Port: 7001    │  │
│   └─────────────────┘   └─────────────────┘   └─────────────────┘  │
│                                                                      │
│   When client connects, it specifies:                               │
│   • Server IP: 192.168.1.100                                        │
│   • Port: 8080 → connects to Tomcat                                 │
│   • Port: 1521 → connects to Oracle                                 │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Data Transfer: Marshalling & Unmarshalling

```
┌─────────────────────────────────────────────────────────────────────┐
│ How Data Travels Over Network                                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   SENDER                              RECEIVER                      │
│   ┌──────────┐                       ┌──────────┐                  │
│   │   Data   │                       │   Data   │                  │
│   │ (Object) │                       │ (Object) │                  │
│   └────┬─────┘                       └────▲─────┘                  │
│        │                                  │                         │
│        ▼                                  │                         │
│   ┌────────────┐                    ┌────────────┐                 │
│   │MARSHALLING │                    │UNMARSHALLING│                │
│   │ (Convert   │                    │ (Convert   │                 │
│   │ to Packets)│                    │ to Data)   │                 │
│   └────┬───────┘                    └────▲───────┘                 │
│        │                                  │                         │
│        │         Network                  │                         │
│        └───────(Packets)──────────────────┘                         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📡 TCP vs UDP

### Transmission Control Protocol (TCP)

```
┌─────────────────────────────────────────────────────────────────────┐
│ TCP - Transmission Control Protocol                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   Similar to: TELEPHONE SERVICE 📞                                  │
│                                                                      │
│   ┌────────────┐    Connection    ┌────────────┐                   │
│   │   CLIENT   │◄─────────────────►│   SERVER   │                   │
│   │            │    Established    │            │                   │
│   └────────────┘                   └────────────┘                   │
│         │                                │                          │
│         │ 1. Send data                   │                          │
│         ├───────────────────────────────►│                          │
│         │                                │                          │
│         │ 2. Acknowledgment              │                          │
│         │◄───────────────────────────────┤                          │
│         │                                │                          │
│         │ 3. If lost, retransmit         │                          │
│         ├───────────────────────────────►│                          │
│                                                                      │
│   CHARACTERISTICS:                                                   │
│   ✓ Connection-oriented (handshake first)                          │
│   ✓ Reliable delivery guaranteed                                   │
│   ✓ Packets arrive in ORDER                                        │
│   ✓ Sender knows if receiver got message                           │
│   ✗ Slower due to reliability overhead                             │
│                                                                      │
│   USE CASES: HTTP, FTP, SMTP, Database connections                  │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### User Datagram Protocol (UDP)

```
┌─────────────────────────────────────────────────────────────────────┐
│ UDP - User Datagram Protocol                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   Similar to: POSTAL SERVICE 📮                                     │
│                                                                      │
│   ┌────────────┐                  ┌────────────┐                   │
│   │   CLIENT   │                  │   SERVER   │                   │
│   │            │   No Connection  │            │                   │
│   └────────────┘                  └────────────┘                   │
│         │                                                           │
│         │ Send packet 1 ─────────────────────────►?                │
│         │ Send packet 2 ─────────────────────────►?                │
│         │ Send packet 3 ─────────────────────────►?                │
│         │                                                           │
│         │ No acknowledgment! Don't know if received                │
│                                                                      │
│   CHARACTERISTICS:                                                   │
│   ✓ Connectionless (no handshake)                                  │
│   ✓ Very fast                                                       │
│   ✓ Low overhead                                                    │
│   ✗ No delivery guarantee                                          │
│   ✗ Packets may arrive out of order                                │
│   ✗ Sender doesn't know if receiver got message                    │
│                                                                      │
│   USE CASES: Video streaming, Gaming, DNS, VoIP                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Comparison Table

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Guaranteed delivery | No guarantee |
| Order | Maintains packet order | No ordering |
| Speed | Slower | Faster |
| Overhead | Higher | Lower |
| Acknowledgment | Yes | No |
| Use Case | File transfer, Web | Streaming, Gaming |

---

## 🔢 Port Numbers

### Port Range

```
┌─────────────────────────────────────────────────────────────────────┐
│ Port Number Ranges                                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   TOTAL RANGE: 1 to 65535                                           │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐  │
│   │ 1 - 1023: WELL-KNOWN PORTS (Reserved for System)            │  │
│   │                                                              │  │
│   │   HTTP   : 80                                               │  │
│   │   HTTPS  : 443                                              │  │
│   │   FTP    : 21                                               │  │
│   │   SSH    : 22                                               │  │
│   │   Telnet : 23                                               │  │
│   │   SMTP   : 25                                               │  │
│   │   DNS    : 53                                               │  │
│   └─────────────────────────────────────────────────────────────┘  │
│                                                                      │
│   ┌─────────────────────────────────────────────────────────────┐  │
│   │ 1024 - 65535: AVAILABLE FOR USER APPLICATIONS               │  │
│   │                                                              │  │
│   │   ✓ Use these ports for your Java socket programs          │  │
│   │   ✓ Common choices: 5000, 8000, 8080, 10000                 │  │
│   └─────────────────────────────────────────────────────────────┘  │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔌 TCP Socket Programming

### Key Classes

**Socket (Client-side):**
- Connects to server
- When instantiated, needs: server hostname + port number
- Represents connection TO server

**ServerSocket (Server-side):**
- Waits for client connections
- `accept()` method blocks until client connects
- Returns Socket representing the client

### TCP Server Implementation

```java
// FILE: TcpServer.java
// =====================

import java.io.*;     // Line 1: For Input/Output streams
import java.net.*;    // Line 2: For Socket classes

public class TcpServer {
    public static void main(String args[]) {
        try {
            // Line 3: Create ServerSocket on port 10000
            // This makes server READY and WAITING for connections
            ServerSocket sc = new ServerSocket(10000);
            
            // Line 4: accept() - BLOCKS until client connects
            // When client connects, returns Socket representing that client
            Socket ss = sc.accept();
            // ss = Socket to communicate with connected client
            
            // Line 5: Get INPUT stream from client (to READ data)
            InputStream i = ss.getInputStream();
            
            // Line 6: Get OUTPUT stream to client (to WRITE data)
            OutputStream o = ss.getOutputStream();
            
            // Line 7-8: Wrap streams with DataInputStream/DataOutputStream
            // DataInputStream/DataOutputStream allow reading/writing primitives & strings
            DataOutputStream dos = new DataOutputStream(o);
            DataInputStream dis = new DataInputStream(i);
            
            // Line 9: Buffer for reading from console
            byte b[] = new byte[200];
            String str = "";
            
            // Line 10-18: Communication loop
            while (true) {
                // Line 11: READ from client using readUTF()
                // readUTF() reads String written by writeUTF()
                str = dis.readUTF();
                System.out.println("Request from client is  " + str);
                
                // Line 12-14: Get response from console
                System.out.println("Enter response to client");
                int k = System.in.read(b);        // Read from keyboard
                str = new String(b, 0, k - 2);    // Convert to String (remove \r\n)
                
                // Line 15: WRITE to client using writeUTF()
                dos.writeUTF(str);
            }
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

**Flow Diagram:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ TCP Server Flow                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   1. ServerSocket(10000)                                            │
│      ├── Server binds to port 10000                                 │
│      └── Ready to accept connections                                │
│                                                                      │
│   2. accept() [BLOCKING]                                            │
│      ├── Waits until client connects                                │
│      └── Returns Socket for that client                             │
│                                                                      │
│   3. Get Streams                                                    │
│      ├── InputStream  ← READ from client                            │
│      └── OutputStream → WRITE to client                             │
│                                                                      │
│   4. Communication Loop                                             │
│      ├── readUTF()  ← Receive client request                        │
│      ├── Process request (get response from console)                │
│      └── writeUTF() → Send response to client                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### TCP Client Implementation

```java
// FILE: TcpClient.java
// =====================

import java.io.*;     // Line 1: For Input/Output streams
import java.net.*;    // Line 2: For Socket classes

public class TcpClient {
    public static void main(String args[]) {
        try {
            // Line 3: Create Socket to connect to server
            // Parameters: (hostname, port)
            // "LAPTOP-DM7E4AA9" = server's hostname/IP
            // 10000 = port on which server is listening
            Socket ss = new Socket("LAPTOP-DM7E4AA9", 10000);
            // Connection is established at this point!
            
            // Line 4: Get INPUT stream (to READ from server)
            InputStream i = ss.getInputStream();
            
            // Line 5: Get OUTPUT stream (to WRITE to server)
            OutputStream o = ss.getOutputStream();
            
            // Line 6-7: Wrap with DataInputStream/DataOutputStream
            DataOutputStream dos = new DataOutputStream(o);
            DataInputStream dis = new DataInputStream(i);
            
            // Line 8: Buffer for console input
            byte b[] = new byte[200];
            String str = "";
            
            // Line 9-17: Communication loop
            while (true) {
                // Line 10-12: Get request from console
                System.out.println("Enter request to server");
                int k = System.in.read(b);
                str = new String(b, 0, k - 2);  // Remove \r\n
                
                // Line 13: SEND request to server
                dos.writeUTF(str);
                
                // Line 14: RECEIVE response from server
                str = dis.readUTF();
                System.out.println("Response from server is  " + str);
            }
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

**Complete TCP Communication Flow:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ TCP Client-Server Communication                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   SERVER (TcpServer)                    CLIENT (TcpClient)          │
│   ─────────────────                     ────────────────            │
│                                                                      │
│   1. ServerSocket(10000)                                            │
│      [Listening on port 10000]                                      │
│              │                                                       │
│              │     2. new Socket("server", 10000)                   │
│              │◄────────────────────────────────────                  │
│              │         Connection Request                            │
│              │                                                       │
│   3. accept() returns Socket                                        │
│              │─────────────────────────────────────►                │
│              │         Connection Established                       │
│              │                                                       │
│              │◄──────── 4. writeUTF("Hello") ────────               │
│              │              CLIENT sends request                    │
│              │                                                       │
│   5. readUTF() receives "Hello"                                     │
│   6. Process and prepare response                                   │
│              │                                                       │
│              │──────── 7. writeUTF("Hi back") ─────►                │
│              │              SERVER sends response                   │
│              │                                                       │
│              │◄──────── 8. readUTF() receives ──────                │
│              │              CLIENT receives "Hi back"               │
│                                                                      │
│   [Loop continues...]                                               │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📨 UDP Socket Programming

### Key Classes

**DatagramSocket:**
- Used for both sending and receiving UDP packets
- Not connection-oriented

**DatagramPacket:**
- Container for data being sent/received
- Contains: data, length, destination address, port

### UDP Server Implementation

```java
// FILE: UdpServer.java
// =====================

import java.io.*;
import java.net.*;

public class UdpServer {
    static int port = 5000;  // Line 1: Port to listen on
    
    public static void main(String args[]) {
        try {
            // Line 2: Create DatagramSocket bound to port 5000
            // This socket will RECEIVE packets on port 5000
            DatagramSocket sock = new DatagramSocket(port);
            
            // Line 3: Infinite loop to receive packets
            while (true) {
                // Line 4: Create buffer to hold incoming data
                byte data[] = new byte[100];
                
                // Line 5: Create empty DatagramPacket to receive data
                // Packet will be filled when data arrives
                DatagramPacket pack = new DatagramPacket(data, data.length);
                
                // Line 6: receive() - BLOCKS until packet arrives
                // Similar to accept() in TCP, but for single packet
                sock.receive(pack);
                
                // Line 7: Convert received bytes to String
                // pack.getLength() gives actual data length
                String ss = new String(data, 0, pack.getLength());
                
                // Line 8: Display received message
                System.out.println(ss);
            }
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### UDP Client Implementation

```java
// FILE: UdpClient.java
// =====================

import java.io.*;
import java.net.*;

public class UdpClient {
    static int port = 5000;  // Line 1: Server's port
    
    public static void main(String args[]) {
        try {
            // Line 2: Get message from command line argument
            // args[1] = message to send
            byte data[] = args[1].getBytes();
            
            // Line 3: Get server's IP address
            // args[0] = server hostname/IP
            InetAddress id = InetAddress.getByName(args[0]);
            System.out.println(id);
            
            // Line 4: Create DatagramPacket with destination
            // Parameters: (data, length, destination IP, destination port)
            DatagramPacket pack = new DatagramPacket(data, data.length, id, port);
            
            // Line 5: Create DatagramSocket for sending
            // No port needed - system assigns random available port
            DatagramSocket sock = new DatagramSocket();
            
            // Line 6: SEND the packet
            // Fire and forget - no confirmation!
            sock.send(pack);
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}

// USAGE: java UdpClient localhost "Hello Server"
```

**UDP Communication Flow:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ UDP Communication Flow                                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   SERVER                               CLIENT                       │
│   ──────                               ──────                       │
│                                                                      │
│   DatagramSocket(5000)                                              │
│   [Listening on port 5000]                                          │
│              │                                                       │
│              │         DatagramSocket()                             │
│              │         [Any available port]                         │
│              │                                                       │
│              │◄──────── DatagramPacket ─────────                    │
│              │         (data + destination)                         │
│   receive()  │         sock.send(packet)                            │
│   [Gets packet]                                                     │
│              │                                                       │
│   Process data│                                                      │
│              │                                                       │
│              │         NO ACKNOWLEDGMENT!                           │
│              │         Client doesn't know if                       │
│              ×         packet was received                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🌍 URL and URLConnection

### Reading Web Content

```java
// FILE: UrlDemo1.java
// ====================

import java.net.*;
import java.io.*;
import java.util.*;

public class UrlDemo1 {
    public static void main(String args[]) {
        try {
            // Line 1: Create URL object for Facebook
            URL u = new URL("https://www.facebook.com/");
            
            // Line 2: Open connection to URL
            // URLConnection allows reading data from the URL
            URLConnection con = u.openConnection();
            
            // Line 3-8: Get date of the resource
            long d = con.getDate();
            if (d == 0) {
                System.out.println("No Date Information");
            } else {
                System.out.println("Date is\t" + new Date(d));
            }
            
            // Line 9: Get content type (e.g., text/html)
            System.out.println("Content type is\t" + con.getContentType());
            
            // Line 10-19: Read content from URL
            int len = con.getContentLength();
            if (len != 0) {
                System.out.println("Contents are:");
                
                // Get InputStream from connection
                InputStream input = con.getInputStream();
                
                int ch;
                // Read character by character
                while ((ch = input.read()) != -1) {
                    System.out.print((char) ch);
                }
            } else {
                System.out.println("No contents available");
            }
            
        } catch (Exception mm) {
            System.out.println("Exception is\t" + mm);
        }
    }
}
```

**URL Components:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ URL Structure                                                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   https://www.example.com:8080/path/page.html?query=value#anchor    │
│   ─────   ─────────────── ──── ─────────────── ─────────── ──────   │
│     │           │          │         │              │         │     │
│   Protocol    Host       Port      Path          Query    Fragment  │
│                                                                      │
│   Methods:                                                          │
│   • getProtocol() → "https"                                         │
│   • getHost()     → "www.example.com"                               │
│   • getPort()     → 8080                                            │
│   • getPath()     → "/path/page.html"                               │
│   • getQuery()    → "query=value"                                   │
│   • getRef()      → "anchor"                                        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 👥 Multi-Client Server

### The Problem

A simple TCP server can only handle ONE client at a time. While serving one client, others must wait.

### The Solution: Multi-threaded Server

Create a new thread for each connected client.

```java
// FILE: MultiServer.java
// =======================

import java.io.*;
import java.net.*;

// Thread class to handle each client
class mythread extends Thread {
    Socket mySocket;              // Socket for this client
    DataOutputStream dos;          // Output stream to client
    
    // Constructor receives client socket
    mythread(Socket mySocket) {
        this.mySocket = mySocket;
        try {
            // Get output stream for this client
            dos = new DataOutputStream(mySocket.getOutputStream());
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
    
    // run() method - executed when thread starts
    public void run() {
        try {
            // Send welcome message to client
            dos.writeUTF("Welcome to our site");
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}

public class MultiServer {
    public static void main(String args[]) {
        try {
            // Create ServerSocket on port 8000
            ServerSocket ss = new ServerSocket(8000);
            
            // Infinite loop - accept clients continuously
            while (true) {
                // accept() blocks until client connects
                Socket s = ss.accept();
                
                // Print client's hostname
                System.out.println(s.getInetAddress().getHostName() + "\tgot connected");
                
                // Create NEW thread for this client and START it
                // Main thread immediately returns to accept() for next client
                new mythread(s).start();
            }
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

**Multi-Client Flow:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Multi-threaded Server Architecture                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   MAIN THREAD                                                       │
│   ───────────                                                       │
│   ServerSocket(8000)                                                │
│         │                                                            │
│         │ while(true)                                               │
│         ▼                                                            │
│   ┌──────────┐                                                      │
│   │ accept() │──► Client1 connects                                  │
│   └────┬─────┘    ├── Create Thread1 for Client1                   │
│        │          └── Thread1.start()                               │
│        │                    │                                        │
│        │                    ▼                                        │
│        │          ┌─────────────────┐                               │
│        │          │ THREAD 1        │                               │
│        │          │ handles Client1 │                               │
│        │          └─────────────────┘                               │
│        ▼                                                             │
│   ┌──────────┐                                                      │
│   │ accept() │──► Client2 connects                                  │
│   └────┬─────┘    ├── Create Thread2 for Client2                   │
│        │          └── Thread2.start()                               │
│        │                    │                                        │
│        │                    ▼                                        │
│        │          ┌─────────────────┐                               │
│        │          │ THREAD 2        │                               │
│        │          │ handles Client2 │                               │
│        │          └─────────────────┘                               │
│        ▼                                                             │
│   [Ready for more clients...]                                       │
│                                                                      │
│   RESULT: Multiple clients served SIMULTANEOUSLY!                   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Multi-Client Client

```java
// FILE: Client.java (for Multi-Server)
// =====================================

import java.io.*;
import java.net.*;

public class Client {
    public static void main(String args[]) {
        try {
            // Connect to multi-threaded server
            Socket ss = new Socket("LAPTOP-DM7E4AA9", 8000);
            
            // Get input stream to read server response
            InputStream i = ss.getInputStream();
            DataInputStream dis = new DataInputStream(i);
            
            // Read welcome message from server
            String str = dis.readUTF();
            System.out.println("Response from server is  " + str);
            // Output: Response from server is  Welcome to our site
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

---

## 📦 Sending Objects Over Network

### Can We Send Objects?

**Yes!** But the class must implement `Serializable` because:
- Object gets serialized (marshalling) when sent
- Object gets deserialized (unmarshalling) when received

### Object-Sending Server

```java
// FILE: TcpServer.java (Object Transfer)
// ======================================

import java.io.*;
import java.net.*;
import java.util.*;

public class TcpServer {
    public static void main(String args[]) {
        try {
            // Create server socket
            ServerSocket sc = new ServerSocket(10000);
            
            // Wait for client connection
            Socket ss = sc.accept();
            
            // Get input stream
            InputStream i = ss.getInputStream();
            
            // Wrap with ObjectInputStream to READ OBJECTS
            ObjectInputStream ois = new ObjectInputStream(i);
            
            // READ object from client (cast to List)
            // readObject() deserializes the object
            List list = (List) ois.readObject();
            
            System.out.println("Order from client is\t" + list);
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### Object-Sending Client

```java
// FILE: TcpClient.java (Object Transfer)
// ======================================

/*
 * IMPORTANT: Thread.sleep(200) is called after writeObject()
 * 
 * WHY? Without sleep, client socket closes immediately after
 * code terminates. Server might not have time to read the object
 * and gets "java.net.SocketException: Connection reset"
 * 
 * With sleep(200), client waits 200ms giving server time to read.
 */

import java.io.*;
import java.net.*;
import java.util.*;

public class TcpClient {
    public static void main(String args[]) {
        try {
            // Connect to server
            Socket ss = new Socket("LAPTOP-DM7E4AA9", 10000);
            
            // Get output stream
            OutputStream o = ss.getOutputStream();
            
            // Wrap with ObjectOutputStream to WRITE OBJECTS
            ObjectOutputStream oos = new ObjectOutputStream(o);
            
            // Create ArrayList (implements Serializable)
            List<String> mylist = new ArrayList<String>();
            
            // Get book names from user
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter book names to order, type quit to stop");
            
            while (true) {
                String str = sc.nextLine();
                if (str.equalsIgnoreCase("quit")) {
                    break;
                }
                mylist.add(str);
            }
            
            // SEND the ArrayList object to server
            // writeObject() serializes and sends the object
            oos.writeObject(mylist);
            
            // Wait for server to receive before closing
            try {
                Thread.sleep(200);
            } catch (InterruptedException ie) {
                ie.printStackTrace();
            }
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

**Object Transfer Flow:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Object Transfer Over Network                                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   CLIENT                               SERVER                       │
│   ──────                               ──────                       │
│                                                                      │
│   ArrayList<String> mylist                                          │
│   ["Book1", "Book2", "Book3"]                                       │
│         │                                                            │
│         ▼                                                            │
│   ObjectOutputStream                                                │
│   .writeObject(mylist)                                              │
│         │                                                            │
│         │  SERIALIZATION (Marshalling)                              │
│         │  Convert object to byte stream                            │
│         │                                                            │
│         │         ════════════════════════════                      │
│         │──────────────  NETWORK  ────────────────►                 │
│                   ════════════════════════════                      │
│                                        │                             │
│                                        │  DESERIALIZATION           │
│                                        │  (Unmarshalling)           │
│                                        │  Convert bytes to object   │
│                                        ▼                             │
│                               ObjectInputStream                     │
│                               .readObject()                         │
│                                        │                             │
│                                        ▼                             │
│                               List = (List) readObject()           │
│                               ["Book1", "Book2", "Book3"]           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📝 Interview Questions

### Q1: What is the difference between TCP and UDP?
**Answer:**
- **TCP**: Connection-oriented, reliable, ordered delivery, acknowledgments, slower
- **UDP**: Connectionless, unreliable, no ordering, no acknowledgments, faster

### Q2: What is the role of ServerSocket.accept()?
**Answer:** The `accept()` method blocks the server thread until a client connects. When a client connects, it returns a `Socket` object representing that client connection.

### Q3: Can we send objects over network? How?
**Answer:** Yes, using `ObjectInputStream` and `ObjectOutputStream`. The object's class must implement `Serializable`. Object is serialized (marshalled) when sent and deserialized (unmarshalled) when received.

### Q4: What is the difference between Socket and ServerSocket?
**Answer:**
- **Socket**: Used by client to connect to server; also returned by server's accept() to represent client
- **ServerSocket**: Used only by server to listen for incoming connections

### Q5: What is port number and its range in Java?
**Answer:** Port number identifies a specific application on a server. Range is 1-65535. Ports 1-1023 are reserved for system applications. Java applications should use ports 1024-65535.

### Q6: How to handle multiple clients in TCP server?
**Answer:** Use multi-threading. Main thread accepts connections in a loop. For each connected client, create a new thread to handle that client. This allows simultaneous client handling.

### Q7: What is marshalling and unmarshalling?
**Answer:**
- **Marshalling**: Converting data/objects into packets for network transmission (serialization)
- **Unmarshalling**: Converting received packets back into data/objects (deserialization)

---

> [!TIP]
> **Testing Tip:** When testing socket programs on the same machine, use "localhost" or "127.0.0.1" as the server address. Make sure to run the server before the client!

