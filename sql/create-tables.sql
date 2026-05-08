
/* =========================
   1. BASIC REFERENCE TABLES
   ========================= */

CREATE TABLE Department (
    department_id NUMBER(5),
    dept_name VARCHAR2(100),
    floor NUMBER(2),
    phone_ext VARCHAR2(20),

    CONSTRAINT pk_department PRIMARY KEY (department_id)
);

CREATE TABLE Specialty (
    specialty_id NUMBER(5),
    specialty_name VARCHAR2(100),
    description VARCHAR2(255),

    CONSTRAINT pk_specialty PRIMARY KEY (specialty_id)
);

CREATE TABLE Supplier (
    supplier_id NUMBER(5),
    supplier_name VARCHAR2(100),
    contact_person VARCHAR2(100),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    address VARCHAR2(150),

    CONSTRAINT pk_supplier PRIMARY KEY (supplier_id)
);

CREATE TABLE Medication (
    med_id NUMBER(5),
    med_name VARCHAR2(100),
    generic_name VARCHAR2(100),
    dosage_form VARCHAR2(50),
    unit VARCHAR2(30),
    stock_qty NUMBER(6),

    CONSTRAINT pk_medication PRIMARY KEY (med_id)
);


/* =========================
   2. HOSPITAL RESOURCES
   ========================= */

CREATE TABLE Room (
    room_id NUMBER(5),
    room_number VARCHAR2(20),
    room_type VARCHAR2(50),
    capacity NUMBER(3),
    is_available VARCHAR2(10),
    department_id NUMBER(5),

    CONSTRAINT pk_room PRIMARY KEY (room_id),
    CONSTRAINT fk_room_department FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);

CREATE TABLE Staff (
    staff_id NUMBER(5),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    role VARCHAR2(50),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    hire_date DATE,
    salary NUMBER(10,2),
    contract_type VARCHAR2(50),
    department_id NUMBER(5),

    CONSTRAINT pk_staff PRIMARY KEY (staff_id),
    CONSTRAINT fk_staff_department FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);

CREATE TABLE Equipment (
    equip_id NUMBER(5),
    equip_name VARCHAR2(100),
    purchase_date DATE,
    status VARCHAR2(50),
    last_service_date DATE,
    department_id NUMBER(5),

    CONSTRAINT pk_equipment PRIMARY KEY (equip_id),
    CONSTRAINT fk_equipment_department FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);


/* =========================
   3. CORE ENTITIES
   ========================= */

CREATE TABLE Patient (
    patient_id NUMBER(5),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    date_of_birth DATE,
    gender VARCHAR2(10),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    address VARCHAR2(150),
    blood_type VARCHAR2(5),
    allergies VARCHAR2(255),

    CONSTRAINT pk_patient PRIMARY KEY (patient_id)
);

CREATE TABLE Doctor (
    doctor_id NUMBER(5),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    license_number VARCHAR2(50),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    hire_date DATE,
    specialty_id NUMBER(5),
    department_id NUMBER(5),

    CONSTRAINT pk_doctor PRIMARY KEY (doctor_id),
    CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id)
        REFERENCES Specialty(specialty_id),
    CONSTRAINT fk_doctor_department FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);

CREATE TABLE Nurse (
    nurse_id NUMBER(5),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    phone VARCHAR2(20),
    hire_date DATE,
    shift_type VARCHAR2(30),
    department_id NUMBER(5),

    CONSTRAINT pk_nurse PRIMARY KEY (nurse_id),
    CONSTRAINT fk_nurse_department FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);

CREATE TABLE Surgery (
    surgery_id NUMBER(5),
    surgery_type VARCHAR2(100),
    surgery_date DATE,
    duration_min NUMBER(5),
    outcome VARCHAR2(255),
    room_id NUMBER(5),

    CONSTRAINT pk_surgery PRIMARY KEY (surgery_id),
    CONSTRAINT fk_surgery_room FOREIGN KEY (room_id)
        REFERENCES Room(room_id)
);

CREATE TABLE Doctor_Surgery (
    doctor_id NUMBER(5),
    surgery_id NUMBER(5),

    CONSTRAINT pk_doctor_surgery PRIMARY KEY (doctor_id, surgery_id),
    CONSTRAINT fk_doctor_surgery_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id),
    CONSTRAINT fk_doctor_surgery_surgery FOREIGN KEY (surgery_id)
        REFERENCES Surgery(surgery_id)
);

CREATE TABLE Patient_Surgery (
    patient_id NUMBER(5),
    surgery_id NUMBER(5),

    CONSTRAINT pk_patient_surgery PRIMARY KEY (patient_id, surgery_id),
    CONSTRAINT fk_patient_surgery_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),
    CONSTRAINT fk_patient_surgery_surgery FOREIGN KEY (surgery_id)
        REFERENCES Surgery(surgery_id)
);


/* =========================
   4. APPOINTMENTS AND MEDICAL RECORDS
   ========================= */

CREATE TABLE Appointment (
    appointment_id NUMBER(5),
    appt_date DATE,
    appt_time VARCHAR2(10),
    status VARCHAR2(30),
    reason VARCHAR2(255),
    patient_id NUMBER(5),
    doctor_id NUMBER(5),
    staff_id NUMBER(5),

    CONSTRAINT pk_appointment PRIMARY KEY (appointment_id),
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id),
    CONSTRAINT fk_appointment_staff FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id)
);

CREATE TABLE Consultation (
    consultation_id NUMBER(5),
    consultation_date DATE,
    notes VARCHAR2(500),
    appointment_id NUMBER(5),
    room_id NUMBER(5),
    doctor_id NUMBER(5),

    CONSTRAINT pk_consultation PRIMARY KEY (consultation_id),
    CONSTRAINT fk_consultation_appointment FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id),
    CONSTRAINT fk_consultation_room FOREIGN KEY (room_id)
        REFERENCES Room(room_id),
    CONSTRAINT fk_consultation_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
);

CREATE TABLE VitalSigns (
    vital_id NUMBER(5),
    heart_rate NUMBER(3),
    systolic_bp NUMBER(3),
    diastolic_bp NUMBER(3),
    temperature NUMBER(4,1),
    respiratory_rate NUMBER(3),
    weight_kg NUMBER(5,2),
    height_cm NUMBER(5,2),
    pain_scale NUMBER(2),
    nurse_id NUMBER(5),
    consultation_id NUMBER(5),

    CONSTRAINT pk_vitalsigns PRIMARY KEY (vital_id),
    CONSTRAINT fk_vitalsigns_nurse FOREIGN KEY (nurse_id)
        REFERENCES Nurse(nurse_id),
    CONSTRAINT fk_vitalsigns_consultation FOREIGN KEY (consultation_id)
        REFERENCES Consultation(consultation_id)
);

CREATE TABLE ClinicalHistory (
    history_id NUMBER(5),
    event_type VARCHAR2(50),
    condition_name VARCHAR2(100),
    event_date DATE,
    end_date DATE,
    outcome VARCHAR2(255),
    notes VARCHAR2(500),
    patient_id NUMBER(5),
    doctor_id NUMBER(5),

    CONSTRAINT pk_clinicalhistory PRIMARY KEY (history_id),
    CONSTRAINT fk_clinicalhistory_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),
    CONSTRAINT fk_clinicalhistory_doctor FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
);

CREATE TABLE Diagnosis (
    diagnosis_id NUMBER(5),
    icd_code VARCHAR2(20),
    description VARCHAR2(255),
    severity VARCHAR2(50),
    is_chronic VARCHAR2(10),
    consultation_id NUMBER(5),

    CONSTRAINT pk_diagnosis PRIMARY KEY (diagnosis_id),
    CONSTRAINT fk_diagnosis_consultation FOREIGN KEY (consultation_id)
        REFERENCES Consultation(consultation_id)
);

CREATE TABLE LabTest (
    test_id NUMBER(5),
    test_name VARCHAR2(100),
    ordered_date DATE,
    result_date DATE,
    result_value VARCHAR2(255),
    status VARCHAR2(30),
    consultation_id NUMBER(5),

    CONSTRAINT pk_labtest PRIMARY KEY (test_id),
    CONSTRAINT fk_labtest_consultation FOREIGN KEY (consultation_id)
        REFERENCES Consultation(consultation_id)
);


/* =========================
   5. PRESCRIPTIONS
   ========================= */

CREATE TABLE Prescription (
    presc_id NUMBER(5),
    issue_date DATE,
    expiry_date DATE,
    consultation_id NUMBER(5),

    CONSTRAINT pk_prescription PRIMARY KEY (presc_id),
    CONSTRAINT fk_prescription_consultation FOREIGN KEY (consultation_id)
        REFERENCES Consultation(consultation_id)
);

CREATE TABLE PrescriptionLine (
    line_id NUMBER(5),
    dosage VARCHAR2(50),
    frequency VARCHAR2(50),
    duration_days NUMBER(4),
    instructions VARCHAR2(255),
    presc_id NUMBER(5),
    med_id NUMBER(5),

    CONSTRAINT pk_prescriptionline PRIMARY KEY (line_id),
    CONSTRAINT fk_prescriptionline_prescription FOREIGN KEY (presc_id)
        REFERENCES Prescription(presc_id),
    CONSTRAINT fk_prescriptionline_medication FOREIGN KEY (med_id)
        REFERENCES Medication(med_id)
);

CREATE TABLE Medication_Supplier (
    med_id NUMBER(5),
    supplier_id NUMBER(5),

    CONSTRAINT pk_medication_supplier PRIMARY KEY (med_id, supplier_id),
    CONSTRAINT fk_medication_supplier_medication FOREIGN KEY (med_id)
        REFERENCES Medication(med_id),
    CONSTRAINT fk_medication_supplier_supplier FOREIGN KEY (supplier_id)
        REFERENCES Supplier(supplier_id)
);


/* =========================
   6. HOSPITALISATION
   ========================= */

CREATE TABLE Hospitalisation (
    hosp_id NUMBER(5),
    admit_date DATE,
    discharge_date DATE,
    reason VARCHAR2(255),
    patient_id NUMBER(5),
    room_id NUMBER(5),

    CONSTRAINT pk_hospitalisation PRIMARY KEY (hosp_id),
    CONSTRAINT fk_hospitalisation_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),
    CONSTRAINT fk_hospitalisation_room FOREIGN KEY (room_id)
        REFERENCES Room(room_id)
);


/* =========================
   7. BILLING AND INSURANCE
   ========================= */

CREATE TABLE Invoice (
    invoice_id NUMBER(5),
    issue_date DATE,
    total_amount NUMBER(10,2),
    status VARCHAR2(30),
    due_date DATE,
    patient_id NUMBER(5),
    staff_id NUMBER(5),

    CONSTRAINT pk_invoice PRIMARY KEY (invoice_id),
    CONSTRAINT fk_invoice_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),
    CONSTRAINT fk_invoice_staff FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id)
);

CREATE TABLE Payment (
    payment_id NUMBER(5),
    amount_paid NUMBER(10,2),
    payment_date DATE,
    method VARCHAR2(30),
    invoice_id NUMBER(5),

    CONSTRAINT pk_payment PRIMARY KEY (payment_id),
    CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id)
);

CREATE TABLE Insurance (
    insurance_id NUMBER(5),
    provider_name VARCHAR2(100),
    policy_number VARCHAR2(50),
    coverage_pct NUMBER(5,2),
    expiry_date DATE,
    patient_id NUMBER(5),

    CONSTRAINT pk_insurance PRIMARY KEY (insurance_id),
    CONSTRAINT fk_insurance_patient FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id)
);


/* =========================
   8. CERTIFICATION
   ========================= */

CREATE TABLE MedicalCertification (
    cert_id NUMBER(5),
    issue_date DATE,
    valid_days NUMBER(4),
    purpose VARCHAR2(255),
    consultation_id NUMBER(5),

    CONSTRAINT pk_medicalcertification PRIMARY KEY (cert_id),
    CONSTRAINT fk_medicalcertification_consultation FOREIGN KEY (consultation_id)
        REFERENCES Consultation(consultation_id)
);
