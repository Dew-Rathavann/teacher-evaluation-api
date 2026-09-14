-- CreateEnum
CREATE TYPE "evaluation_status" AS ENUM ('DRAFT', 'OPEN', 'CLOSED');

-- CreateEnum
CREATE TYPE "question_type" AS ENUM ('RATING', 'TEXT');

-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('ADMIN', 'LECTURER', 'STUDENT');

-- CreateEnum
CREATE TYPE "user_status" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "survey_version_status" AS ENUM ('DRAFT', 'LOCKED', 'ARCHIVED');

-- CreateTable
CREATE TABLE "answers" (
    "id" BIGSERIAL NOT NULL,
    "response_id" BIGINT NOT NULL,
    "question_id" BIGINT NOT NULL,
    "rating_value" INTEGER,
    "text_value" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "answers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course_offerings" (
    "id" BIGSERIAL NOT NULL,
    "course_id" BIGINT NOT NULL,
    "lecturer_id" BIGINT NOT NULL,
    "semester_id" BIGINT NOT NULL,
    "section_code" VARCHAR(50),
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "course_offerings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses" (
    "id" BIGSERIAL NOT NULL,
    "course_code" VARCHAR(30) NOT NULL,
    "course_name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "courses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "enrollments" (
    "id" BIGSERIAL NOT NULL,
    "student_id" BIGINT NOT NULL,
    "course_offering_id" BIGINT NOT NULL,
    "enrolled_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "enrollments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_participants" (
    "id" BIGSERIAL NOT NULL,
    "evaluation_id" BIGINT NOT NULL,
    "student_id" BIGINT NOT NULL,
    "has_submitted" BOOLEAN NOT NULL DEFAULT false,
    "submitted_at" TIMESTAMP(6),
    "created_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "evaluation_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluations" (
    "id" BIGSERIAL NOT NULL,
    "course_offering_id" BIGINT NOT NULL,
    "survey_version_id" BIGINT NOT NULL,
    "status" "evaluation_status" NOT NULL DEFAULT 'DRAFT',
    "start_at" TIMESTAMP(6),
    "end_at" TIMESTAMP(6),
    "created_by" BIGINT NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "evaluations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questions" (
    "id" BIGSERIAL NOT NULL,
    "survey_version_id" BIGINT NOT NULL,
    "question_text" TEXT NOT NULL,
    "question_type" "question_type" NOT NULL,
    "category" VARCHAR(100),
    "is_required" BOOLEAN NOT NULL DEFAULT true,
    "min_rating" INTEGER,
    "max_rating" INTEGER,
    "display_order" INTEGER NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "responses" (
    "id" BIGSERIAL NOT NULL,
    "evaluation_id" BIGINT NOT NULL,
    "submitted_at" TIMESTAMP(6) NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "responses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "semesters" (
    "id" BIGSERIAL NOT NULL,
    "semester_name" VARCHAR(50) NOT NULL,
    "academic_year" VARCHAR(20) NOT NULL,
    "start_date" DATE,
    "end_date" DATE,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "semesters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "surveys" (
    "id" BIGSERIAL NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "created_by" BIGINT NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "surveys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "survey_versions" (
    "id" BIGSERIAL NOT NULL,
    "survey_id" BIGINT NOT NULL,
    "version_no" INTEGER NOT NULL,
    "status" "survey_version_status" NOT NULL DEFAULT 'DRAFT',
    "locked_at" TIMESTAMP(3),
    "created_by" BIGINT NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "survey_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" BIGSERIAL NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "full_name" VARCHAR(150) NOT NULL,
    "role" "user_role" NOT NULL,
    "status" "user_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(6) NOT NULL,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "answers_response_id_question_id_idx" ON "answers"("response_id", "question_id");

-- CreateIndex
CREATE UNIQUE INDEX "course_offerings_course_id_lecturer_id_semester_id_section__idx" ON "course_offerings"("course_id", "lecturer_id", "semester_id", "section_code");

-- CreateIndex
CREATE UNIQUE INDEX "courses_course_code_key" ON "courses"("course_code");

-- CreateIndex
CREATE UNIQUE INDEX "enrollments_student_id_course_offering_id_idx" ON "enrollments"("student_id", "course_offering_id");

-- CreateIndex
CREATE UNIQUE INDEX "evaluation_participants_evaluation_id_student_id_idx" ON "evaluation_participants"("evaluation_id", "student_id");

-- CreateIndex
CREATE UNIQUE INDEX "evaluations_course_offering_id_survey_version_id_idx" ON "evaluations"("course_offering_id", "survey_version_id");

-- CreateIndex
CREATE UNIQUE INDEX "questions_survey_version_id_display_order_idx" ON "questions"("survey_version_id", "display_order");

-- CreateIndex
CREATE UNIQUE INDEX "semesters_semester_name_academic_year_idx" ON "semesters"("semester_name", "academic_year");

-- CreateIndex
CREATE UNIQUE INDEX "survey_versions_survey_id_version_no_idx" ON "survey_versions"("survey_id", "version_no");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- AddForeignKey
ALTER TABLE "answers" ADD CONSTRAINT "answers_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "questions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "answers" ADD CONSTRAINT "answers_response_id_fkey" FOREIGN KEY ("response_id") REFERENCES "responses"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "course_offerings" ADD CONSTRAINT "course_offerings_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "course_offerings" ADD CONSTRAINT "course_offerings_lecturer_id_fkey" FOREIGN KEY ("lecturer_id") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "course_offerings" ADD CONSTRAINT "course_offerings_semester_id_fkey" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "enrollments" ADD CONSTRAINT "enrollments_course_offering_id_fkey" FOREIGN KEY ("course_offering_id") REFERENCES "course_offerings"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "enrollments" ADD CONSTRAINT "enrollments_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_participants" ADD CONSTRAINT "evaluation_participants_evaluation_id_fkey" FOREIGN KEY ("evaluation_id") REFERENCES "evaluations"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_participants" ADD CONSTRAINT "evaluation_participants_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluations" ADD CONSTRAINT "evaluations_course_offering_id_fkey" FOREIGN KEY ("course_offering_id") REFERENCES "course_offerings"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluations" ADD CONSTRAINT "evaluations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluations" ADD CONSTRAINT "evaluations_survey_version_id_fkey" FOREIGN KEY ("survey_version_id") REFERENCES "survey_versions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "questions" ADD CONSTRAINT "questions_survey_version_id_fkey" FOREIGN KEY ("survey_version_id") REFERENCES "survey_versions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "responses" ADD CONSTRAINT "responses_evaluation_id_fkey" FOREIGN KEY ("evaluation_id") REFERENCES "evaluations"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "surveys" ADD CONSTRAINT "surveys_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "survey_versions" ADD CONSTRAINT "survey_versions_survey_id_fkey" FOREIGN KEY ("survey_id") REFERENCES "surveys"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "survey_versions" ADD CONSTRAINT "survey_versions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
