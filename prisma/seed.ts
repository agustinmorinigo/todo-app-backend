import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function main() {
  // "paymentMethods" data.
  await prisma.paymentMethod.createMany({
    data: [
      { type: 'CASH',    name: 'Efectivo'                },
      { type: 'BNA',     name: 'Transferencia - BNA'     },
      { type: 'MP',      name: 'Transferencia - MP'      },
      { type: 'GALICIA', name: 'Transferencia - GALICIA' },
      { type: 'BBVA',    name: 'Transferencia - BBVA'    },
      { type: 'UALA',    name: 'Transferencia - UALA'    },
      { type: 'BRUBANK', name: 'Transferencia - BRUBANK' },
    ]
  })

  // "vatCategories" data.
  await prisma.vatCategory.createMany({
    data: [
      { type: 'REGISTERED_RESPONSIBLE',     name: 'Responsable inscripto'    },
      { type: 'MONOTAX',                    name: 'Monotributista'           },
      { type: 'EXEMPT',                     name: 'Exento'                   },        
      { type: 'NOT_RESPONSIBLE',            name: 'No responsable'           },
      { type: 'FINAL_CONSUMER',             name: 'Consumidor final'         },
      { type: 'UNCATEGORIZED_SUBJECT',      name: 'Sujeto no categorizado'   },
      { type: 'UNREGISTERED_RESPONSIBLE',   name: 'Responsable no inscripto' },
      { type: 'SUBJECT_TO_VAT_WITHHOLDING', name: 'IVA sujeto a retención'   },
      { type: 'NOT_SUBJECT_TO_VAT',         name: 'IVA no alcanzado'         },
      { type: 'REGISTERED_RESPONSIBLE_M',   name: 'Responsable inscripto M'  },
    ]
  })

  // "expenseCategories" data.
  await prisma.expenseCategory.createMany({
    data: [
      { type: 'OPERATING',     name: 'Operativo'      },
      { type: 'SERVICE',       name: 'Servicio'       },
      { type: 'SUPPLY',        name: 'Insumo'         },
      { type: 'MISCELLANEOUS', name: 'Vario'          },
      { type: 'EXTRAORDINARY', name: 'Extraordinario' },
      { type: 'SALARY',        name: 'Sueldo'         },
      { type: 'DAILY',         name: 'Diario'         },
      { type: 'FUEL',          name: 'Combustible'    },
      { type: 'PERCEPTION',    name: 'Percepción'     },
      { type: 'STATIONERY',    name: 'Librería'       },
      { type: 'CLEANING',      name: 'Limpieza'       },
      { type: 'MAINTENANCE',   name: 'Mantenimiento'  },
      { type: 'CAPTURE',       name: 'Captura'        },
    ]
  })
}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })