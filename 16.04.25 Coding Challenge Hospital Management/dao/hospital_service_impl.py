import pyodbc
from dao.hospital_service import IHospitalService
from entity.appointment import Appointment
from exception.patient_not_found_exception import PatientNumberNotFoundException
from util.db_conn_util import DBConnUtil

class HospitalServiceImpl(IHospitalService):
    def __init__(self):
        self.conn = DBConnUtil.getConnection()

    def getAppointmentById(self, appointmentId):
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment WHERE appointmentId=?", appointmentId)
        row = cursor.fetchone()
        if row:
            return Appointment(*row)
        else:
            return None

    def getAppointmentsForPatient(self, patientId):
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment WHERE patientId=?", patientId)
        rows = cursor.fetchall()
        if not rows:
            raise PatientNumberNotFoundException("Patient ID not found in DB.")
        return [Appointment(*row) for row in rows]

    def getAppointmentsForDoctor(self, doctorId):
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM Appointment WHERE doctorId=?", doctorId)
        rows = cursor.fetchall()
        return [Appointment(*row) for row in rows]

    def scheduleAppointment(self,appointment):
        cursor = self.conn.cursor() 
    
        
        cursor.execute("SELECT COUNT(1) FROM Doctor WHERE doctorId=?", appointment.doctorId)
        if cursor.fetchone()[0] == 0:
            print(f"Error: Doctor ID {appointment.doctorId} does not exist.")
            return False
    
        
        try:
            cursor.execute("""
                INSERT INTO Appointment (appointmentId, doctorId, patientId, appointmentDate, appointmentTime)
                VALUES (?, ?, ?, ?, ?)
            """, appointment.appointmentId, appointment.doctorId, appointment.patientId, appointment.appointmentDate, appointment.appointmentTime)
            self.conn.commit()
            print("Appointment scheduled successfully.")
            return True
        except pyodbc.Error as e:
            print(f"Error scheduling appointment: {e}")
            return False
    

    def updateAppointment(self, appointment):
        cursor = self.conn.cursor()
        query = """
        UPDATE Appointment
        SET patientId=?, doctorId=?, appointmentDate=?, description=?
        WHERE appointmentId=?
        """
        try:
            cursor.execute(query, (appointment.get_patient_id(),
                                   appointment.get_doctor_id(),
                                   appointment.get_appointment_date(),
                                   appointment.get_description(),
                                   appointment.get_appointment_id()))
            self.conn.commit()
            return True
        except Exception as e:
            print(f"Error updating appointment: {e}")
            return False

    def cancelAppointment(self, appointmentId):
        cursor = self.conn.cursor()
        query = "DELETE FROM Appointment WHERE appointmentId=?"
        try:
            cursor.execute(query, appointmentId)
            self.conn.commit()
            return True
        except Exception as e:
            print(f"Error canceling appointment: {e}")
            return False
