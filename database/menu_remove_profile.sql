-- Desactivar opción de perfil (ya no hay autenticación)
UPDATE menu_options SET is_active = FALSE WHERE route = 'profile';
