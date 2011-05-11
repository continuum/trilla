# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110509193929) do

  create_table "clientes", :force => true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fono"
    t.string   "contacto"
  end

  create_table "proyecto_tareas", :force => true do |t|
    t.integer  "proyecto_id"
    t.integer  "tarea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proyecto_usuarios", :force => true do |t|
    t.integer  "proyecto_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "administrador"
  end

  create_table "proyectos", :force => true do |t|
    t.string   "descripcion"
    t.integer  "cliente_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archivado"
    t.string   "codigo"
    t.integer  "estimacion"
    t.boolean  "privado"
  end

  create_table "tareas", :force => true do |t|
    t.string   "descripcion"
    t.string   "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temporizadors", :force => true do |t|
    t.string   "descripcion"
    t.integer  "iniciado"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "proyecto_id"
    t.integer  "tarea_id"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minutos"
    t.datetime "fecha_creacion"
    t.string   "estado"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "nombres"
    t.string   "email"
    t.string   "password"
    t.string   "perfil"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
  end

end
