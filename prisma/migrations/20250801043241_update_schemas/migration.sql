/*
  Warnings:

  - The values [CANCELLED] on the enum `ExpenseStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `date` on the `expenses` table. All the data in the column will be lost.
  - You are about to drop the column `expenseCategoryId` on the `expenses` table. All the data in the column will be lost.
  - You are about to drop the column `link` on the `expenses` table. All the data in the column will be lost.
  - You are about to alter the column `name` on the `users` table. The data in that column could be lost. The data in that column will be cast from `VarChar(100)` to `VarChar(80)`.
  - You are about to drop the `expense_categories` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `expense_items` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `products` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `providers` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `services` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `vat_categories` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `amount` to the `expenses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `categoryId` to the `expenses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `expirationDate` to the `expenses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `invoiceLink` to the `expenses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `organizationId` to the `expenses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `expenses` table without a default value. This is not possible if the table is not empty.
  - Added the required column `documentValue` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lastName` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `role` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `telephone` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'ACCOUNTANT', 'CLERK', 'DOCTOR', 'PATIENT');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('DNI', 'LE', 'LC', 'CI', 'PASSPORT', 'OTHER');

-- CreateEnum
CREATE TYPE "PaymentMethodType" AS ENUM ('CASH', 'BNA', 'MP', 'GALICIA', 'BBVA', 'UALA', 'BRUBANK');

-- AlterEnum
BEGIN;
CREATE TYPE "ExpenseStatus_new" AS ENUM ('PAID', 'PENDING');
ALTER TABLE "expenses" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "expenses" ALTER COLUMN "status" TYPE "ExpenseStatus_new" USING ("status"::text::"ExpenseStatus_new");
ALTER TYPE "ExpenseStatus" RENAME TO "ExpenseStatus_old";
ALTER TYPE "ExpenseStatus_new" RENAME TO "ExpenseStatus";
DROP TYPE "ExpenseStatus_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "expense_items" DROP CONSTRAINT "expense_items_expenseId_fkey";

-- DropForeignKey
ALTER TABLE "expense_items" DROP CONSTRAINT "expense_items_productId_fkey";

-- DropForeignKey
ALTER TABLE "expense_items" DROP CONSTRAINT "expense_items_serviceId_fkey";

-- DropForeignKey
ALTER TABLE "expenses" DROP CONSTRAINT "expenses_expenseCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "providers" DROP CONSTRAINT "providers_vatCategoryId_fkey";

-- DropForeignKey
ALTER TABLE "services" DROP CONSTRAINT "services_providerId_fkey";

-- AlterTable
ALTER TABLE "expenses" DROP COLUMN "date",
DROP COLUMN "expenseCategoryId",
DROP COLUMN "link",
ADD COLUMN     "amount" DECIMAL(12,2) NOT NULL,
ADD COLUMN     "categoryId" INTEGER NOT NULL,
ADD COLUMN     "datePaid" TIMESTAMP(3),
ADD COLUMN     "description" VARCHAR(250),
ADD COLUMN     "expirationDate" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "invoiceLink" VARCHAR(250) NOT NULL,
ADD COLUMN     "organizationId" TEXT NOT NULL,
ADD COLUMN     "paymentMethodId" INTEGER,
ADD COLUMN     "paymentReceiptLink" VARCHAR(250),
ADD COLUMN     "title" VARCHAR(100) NOT NULL,
ALTER COLUMN "status" DROP DEFAULT,
ALTER COLUMN "updatedBy" DROP NOT NULL,
ALTER COLUMN "updatedAt" DROP NOT NULL;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "documentType" "DocumentType" NOT NULL DEFAULT 'DNI',
ADD COLUMN     "documentValue" VARCHAR(30) NOT NULL,
ADD COLUMN     "lastName" VARCHAR(80) NOT NULL,
ADD COLUMN     "role" "UserRole" NOT NULL,
ADD COLUMN     "telephone" VARCHAR(30) NOT NULL,
ALTER COLUMN "name" SET DATA TYPE VARCHAR(80);

-- DropTable
DROP TABLE "expense_categories";

-- DropTable
DROP TABLE "expense_items";

-- DropTable
DROP TABLE "products";

-- DropTable
DROP TABLE "providers";

-- DropTable
DROP TABLE "services";

-- DropTable
DROP TABLE "vat_categories";

-- CreateTable
CREATE TABLE "organizations" (
    "id" TEXT NOT NULL,
    "legalName" VARCHAR(80) NOT NULL,
    "businessName" VARCHAR(80) NOT NULL,
    "address" VARCHAR(180) NOT NULL,
    "vatCategoryId" INTEGER NOT NULL,
    "cuit" VARCHAR(20) NOT NULL,

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vatCategories" (
    "id" SERIAL NOT NULL,
    "type" "VatCategoryType" NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "vatCategories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usersOrganizations" (
    "userId" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,

    CONSTRAINT "usersOrganizations_pkey" PRIMARY KEY ("userId","organizationId")
);

-- CreateTable
CREATE TABLE "expenseCategories" (
    "id" SERIAL NOT NULL,
    "type" "ExpenseCategoryType" NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "expenseCategories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "paymentMethods" (
    "id" SERIAL NOT NULL,
    "type" "PaymentMethodType" NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "paymentMethods_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "organizations_legalName_key" ON "organizations"("legalName");

-- CreateIndex
CREATE UNIQUE INDEX "vatCategories_type_name_key" ON "vatCategories"("type", "name");

-- CreateIndex
CREATE UNIQUE INDEX "expenseCategories_type_name_key" ON "expenseCategories"("type", "name");

-- CreateIndex
CREATE UNIQUE INDEX "paymentMethods_type_name_key" ON "paymentMethods"("type", "name");

-- AddForeignKey
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_vatCategoryId_fkey" FOREIGN KEY ("vatCategoryId") REFERENCES "vatCategories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usersOrganizations" ADD CONSTRAINT "usersOrganizations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usersOrganizations" ADD CONSTRAINT "usersOrganizations_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "expenseCategories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_paymentMethodId_fkey" FOREIGN KEY ("paymentMethodId") REFERENCES "paymentMethods"("id") ON DELETE SET NULL ON UPDATE CASCADE;
