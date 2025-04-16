from dao.hospital_service_impl import HospitalServiceImpl
from entity.appointment import Appointment
from exception.patient_not_found_exception import PatientNumberNotFoundException

def main():
    service = HospitalServiceImpl()

    while True:
        print("\n--- Hospital Management ---")
        print("1. Get Appointment by ID")
        print("2. Get Appointments for Patient")
        print("3. Get Appointments for Doctor")
        print("4. Schedule Appointment")
        print("5. Update Appointment")
        print("6. Cancel Appointment")
        print("7. Exit")
        choice = input("Enter choice: ")

        try:
            if choice == '1':
                aid = input("Enter Appointment ID: ")
                appt = service.getAppointmentById(aid)
                if appt:
                    print("Appointment Details: ", appt)
                else:
                    print("No appointment found with the given ID.")
            
            elif choice == '2':
                pid = input("Enter Patient ID: ")
                appts = service.getAppointmentsForPatient(pid)
                if appts:
                    print("Appointments for Patient: ")
                    for a in appts:
                        print(a)
                else:
                    print("No appointments found for the given Patient ID.")
            
            elif choice == '3':
                did = input("Enter Doctor ID: ")
                appts = service.getAppointmentsForDoctor(did)
                if appts:
                    print("Appointments for Doctor: ")
                    for a in appts:
                        print(a)
                else:
                    print("No appointments found for the given Doctor ID.")
            
            elif choice == '4':
                
                aid = input("Enter Appointment ID: ")
                pid = input("Enter Patient ID: ")
                did = input("Enter Doctor ID: ")
                date = input("Enter Appointment Date (YYYY-MM-DD): ")
                description = input("Enter Appointment Description: ")

                appointment = Appointment(aid, pid, did, date, description)
                success = service.scheduleAppointment(appointment)
                if success:
                    print("Appointment Scheduled Successfully.")
                else:
                    print("Failed to schedule appointment.")
            
            elif choice == '5':
                
                aid = input("Enter Appointment ID to update: ")
                appt = service.getAppointmentById(aid)
                if appt:
                    print("Current Appointment Details: ", appt)
                    pid = input("Enter New Patient ID: ")
                    did = input("Enter New Doctor ID: ")
                    date = input("Enter New Appointment Date (YYYY-MM-DD): ")
                    description = input("Enter New Appointment Description: ")

                    appt.set_patient_id(pid)
                    appt.set_doctor_id(did)
                    appt.set_appointment_date(date)
                    appt.set_description(description)

                    success = service.updateAppointment(appt)
                    if success:
                        print("Appointment Updated Successfully.")
                    else:
                        print("Failed to update appointment.")
                else:
                    print("No appointment found with the given ID.")
            
            elif choice == '6':
                
                aid = input("Enter Appointment ID to cancel: ")
                success = service.cancelAppointment(aid)
                if success:
                    print("Appointment Canceled Successfully.")
                else:
                    print("Failed to cancel appointment.")
            
            elif choice == '7':
                print("Exiting...")
                break
            
            else:
                print("Invalid Choice. Please try again.")

        except PatientNumberNotFoundException as e:
            print(f"Error: {e}")
        except Exception as ex:
            print(f"Unexpected Error: {ex}")

if __name__ == '__main__':
    main()
