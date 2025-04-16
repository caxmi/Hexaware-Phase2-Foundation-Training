class Patient:
    def __init__(self):
        self.__patientId = None
        self.__firstName = None
        self.__lastName = None
        self.__gender = None
        self.__age = None
        self.__phoneNumber = None
        self.__email = None
        self.__address = None

    
    def getPatientId(self): return self.__patientId
    def setPatientId(self, id): self.__patientId = id

    def getFirstName(self): return self.__firstName
    def setFirstName(self, name): self.__firstName = name

    def getLastName(self): return self.__lastName
    def setLastName(self, name): self.__lastName = name

    def getGender(self): return self.__gender
    def setGender(self, gender): self.__gender = gender

    def getAge(self): return self.__age
    def setAge(self, age): self.__age = age

    def getPhoneNumber(self): return self.__phoneNumber
    def setPhoneNumber(self, number): self.__phoneNumber = number

    def getEmail(self): return self.__email
    def setEmail(self, email): self.__email = email

    def getAddress(self): return self.__address
    def setAddress(self, address): self.__address = address
