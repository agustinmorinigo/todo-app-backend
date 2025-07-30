/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `email` on the `User` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(150)`.
  - You are about to alter the column `name` on the `User` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(100)`.
  - Made the column `name` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "ExpenseStatus" AS ENUM ('PENDING', 'PAID', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ExpenseCategoryType" AS ENUM ('OPERATING', 'SERVICE', 'SUPPLY', 'MISCELLANEOUS', 'EXTRAORDINARY', 'SALARY', 'DAILY', 'FUEL', 'PERCEPTION', 'STATIONERY', 'CLEANING', 'MAINTENANCE', 'CAPTURE');

-- CreateEnum
CREATE TYPE "VatCategoryType" AS ENUM ('REGISTERED_RESPONSIBLE', 'MONOTAX', 'EXEMPT', 'NOT_RESPONSIBLE', 'FINAL_CONSUMER', 'UNCATEGORIZED_SUBJECT', 'UNREGISTERED_RESPONSIBLE', 'SUBJECT_TO_VAT_WITHHOLDING', 'NOT_SUBJECT_TO_VAT', 'REGISTERED_RESPONSIBLE_M');

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "email" SET DATA TYPE VARCHAR(150),
ALTER COLUMN "name" SET NOT NULL,
ALTER COLUMN "name" SET DATA TYPE VARCHAR(100),
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "User_id_seq";

-- CreateTable
CREATE TABLE "expenses" (
    "id" TEXT NOT NULL,
    "link" VARCHAR(250) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "status" "ExpenseStatus" NOT NULL DEFAULT 'PENDING',
    "createdBy" TEXT NOT NULL,
    "updatedBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "expenseCategoryId" INTEGER NOT NULL,

    CONSTRAINT "expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_categories" (
    "id" SERIAL NOT NULL,
    "type" "ExpenseCategoryType" NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "expense_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_items" (
    "id" TEXT NOT NULL,
    "unitPrice" DECIMAL(12,2) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "description" VARCHAR(250),
    "productId" INTEGER,
    "serviceId" INTEGER,
    "expenseId" TEXT NOT NULL,

    CONSTRAINT "expense_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "entryDate" TIMESTAMP(3) NOT NULL,
    "expiryDate" TIMESTAMP(3) NOT NULL,
    "providerId" INTEGER NOT NULL,

    CONSTRAINT "services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "providers" (
    "id" SERIAL NOT NULL,
    "legalName" VARCHAR(150) NOT NULL,
    "businessName" VARCHAR(150) NOT NULL,
    "cuit" VARCHAR(80) NOT NULL,
    "email" VARCHAR(150),
    "telephone" VARCHAR(50) NOT NULL,
    "address" VARCHAR(150) NOT NULL,
    "vatCategoryId" INTEGER NOT NULL,

    CONSTRAINT "providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vat_categories" (
    "id" SERIAL NOT NULL,
    "type" "VatCategoryType" NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "vat_categories_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "expense_categories_type_name_key" ON "expense_categories"("type", "name");

-- CreateIndex
CREATE UNIQUE INDEX "providers_cuit_email_key" ON "providers"("cuit", "email");

-- CreateIndex
CREATE UNIQUE INDEX "vat_categories_type_name_key" ON "vat_categories"("type", "name");

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_expenseCategoryId_fkey" FOREIGN KEY ("expenseCategoryId") REFERENCES "expense_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_items" ADD CONSTRAINT "expense_items_productId_fkey" FOREIGN KEY ("productId") REFERENCES "products"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_items" ADD CONSTRAINT "expense_items_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "services"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_items" ADD CONSTRAINT "expense_items_expenseId_fkey" FOREIGN KEY ("expenseId") REFERENCES "expenses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "services_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "providers" ADD CONSTRAINT "providers_vatCategoryId_fkey" FOREIGN KEY ("vatCategoryId") REFERENCES "vat_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
