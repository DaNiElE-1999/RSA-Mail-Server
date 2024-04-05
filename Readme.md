# Email encryption/decryption with RSA 2048

**Assignment for Ethical Hacking Course /**

Developed in Powershell /

### Prerequisites

* [X] Windows OS
* [X] Docker with Linux containers

### Table of Contents

---

* ##### **Concept**

  ****RSA algorithm**** is an asymmetric cryptography algorithm. Asymmetric actually means that it works on two different keys: ****Public Key**** and ****Private Key.**** As the name describes that the Public Key is given to everyone and the Private key is kept private.

  ****An example of asymmetric cryptography: ****


  1. A client (for example browser) sends its public key to the server and requests some data.
  2. The server encrypts the data using the client’s public key and sends the encrypted data.
  3. The client receives this data and decrypts it.

  The way I solved it is by using:

  * **Powershell**
    * To create a "backend" with Windows form, to emulate an e-mail sender UI.
    * When the "send e-mail" button is clicked, a check for the communication channel is performed:
      * This means that if the **sender** and the **reciever** have communicated before, they do not need to exchange the public keys.
      * If they have not, they need to create a communication channel.
    * To create a communication channel, before the email is even sent, both **end users** generate & send to each other their **public key**.
    * The public keys are exchanged by e-mail as requested in the assignment, and this can be seen on the MailHog UI.
    * The sender gets the public key from the reciever, and uses it to encrypt the message.
    * The sender then sends the encrypted message via e-mail. This can be seen on the mailhog UI, and on the text file in the "users/sender/mails directory".
    * The reciever gets the encrypted message, and decrypts it using his private key. This can be see on the Client's UI.
  * MailHog
    * To create a SMTP client for testing purpose, this technology was used.
    * I have used its API to transmit the encrypted e-mails and exchange the keys.
    * Its UI serves also for demostration of this assignment.
* ##### **How to run**

  NOTE: It is very important for the terminal to be opened in the correct path.

Run the SMTP server:

```
docker-compose up
```

Run the e-mail client for the sender:

```
cd powershell 
.\sendEmail.ps1
```

Run the e-mail client for the reciever:

```
cd users/<reciever>
.\readEmail.ps1
```
