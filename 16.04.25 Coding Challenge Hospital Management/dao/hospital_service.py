from abc import ABC, abstractmethod

class IHospitalService(ABC):
    @abstractmethod
    def getAppointmentById(self, appointmentId): pass

    @abstractmethod
    def getAppointmentsForPatient(self, patientId): pass

    @abstractmethod
    def getAppointmentsForDoctor(self, doctorId): pass

    @abstractmethod
    def scheduleAppointment(self, appointment): pass

    @abstractmethod
    def updateAppointment(self, appointment): pass

    @abstractmethod
    def cancelAppointment(self, appointmentId): pass
