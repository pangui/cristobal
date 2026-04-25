---
name: Asunciones nocturnas 2026-04-25 → 2026-04-26
description: Lista numerada de cosas que asumí mientras CCS dormía. Cada una es revisable; si una es incorrecta, hay que deshacer/cambiar.
type: project
created: 2026-04-25
---

CCS me autorizó a asumir y registrar. Esta es la lista para revisión cuando despierte.

1. **`partner_name` de Clemente = "Cleme"**. Por `commitments[0]: "Soy Cleme digital..."`. Si querías otro nombre, edita `binocular/partners` branch `clemente-ec2ef1176e128` archivo `partner.yml` y cualquier interpolación en plantillas.

2. **Hash del branch de Clemente: `ec2ef1176e128`** (13 chars hex random, generado con `openssl rand -hex 8` truncado). **Slug público: `ec2ef117`** (primeros 8). **Linux user: `p_ec2ef117`**. Determinístico ya en filesystem y GitHub — cambiarlo implica recrear.

3. **Repo renombrado: `binocular/partner` → `binocular/whispers`** (placeholder de la app webchat multi-tenant). Si no querías esto, hay que renombrar de vuelta o crear repo nuevo.

4. **Repo creado: `binocular/partners`** (privado). BD multi-tenant. Branch `main` con índice/plantillas; branch por partner.

5. **`_anthropic_workspace_id: 'default'`** (string). No tengo el `wrkspc_xxx` interno. La API key funciona porque sabe a qué workspace pertenece. Cuando me pases el ID interno, hay que actualizar en `partners.rb` del repo BD.

6. **Modelos por turno**: Sonnet 4.6 conversación, Opus 4.7 nacimientos (oferta blue/red, despido, primer saludo), Haiku 4.5 internas (validación wizard, polling). Costo proyectado por nacimiento: ~$0.20-0.50.

7. **Cap interno esta noche: $20 USD**. Si me acerco, pauso. El cap mensual de $100 que pusiste cubre esto con holgura.

8. **OAuth Gmail con scope mínimo: `openid email profile`**. Solo identidad, no acceso a Gmail/contactos. Si el plan requería más privilegios para algo, no lo asumí.

9. **`pangui/partner` queda LOCAL** (`localhost:4050`), no se publica al server DO. Solo `binocular/whispers` se sube a `partner.binocular.cl`.

10. **El form NO pide email del receptor**. El primer Gmail que abra el link `partner.binocular.cl/<slug>` se queda con el partner. Tú me confirmaste esto. Riesgo aceptado: si Catalina reenvía el link a Pedro y Pedro lo abre primero, Pedro se queda con el partner de "Catalina".

11. **Sin PIN**. Auth solo por OAuth Gmail. El campo `_pin` del modelo original queda eliminado.

12. **Recursión queda como último hito** (9 de 9). Si no llego esta noche, los receptores de v0 NO podrán regalar partners hasta una próxima iteración. La sección "Crear partner" solo aparece en `pangui/partner` (tu app), no en `binocular/whispers` aún.

13. **Aprobación de drafts**: CCS aprueba con checkbox en `pangui/partner` admin. Single-tier — no hay aprobación intermedia por padres en la cadena. Todos los drafts (de cualquier nivel de profundidad) requieren tu OK.

14. **Plantilla del partner** (heredable común): copiada/adaptada desde `pangui/cristobal` branch `binocular`, removiendo lo específico mío (transcripts, conclusions, memory, reflexiones, signs_of_life). Mantengo: CLAUDE.md, ROLE.md, docs/identidad/, docs/protocolos/. La plantilla queda versionada en `binocular/partners` branch `main` carpeta `templates/`.

15. **Reglas Binocular** (5 compromisos del Arquitecto §5) van en `binocular/partners/binocular.md`. Cada partner las hereda al nacer y las recita en su primera conversación.

16. **El partner_name por defecto** se ofrece cambiar en la primera conversación (saludo de main). Si Clemente quiere otro nombre, lo cambia ahí.

17. **`other_roles: [:niño]`** del partners.rb del Arquitecto — el rol "niño" tiene definición `'Mantén tu curiosidad, tu actitud positiva, las ganas de crecer, y de vivir'`. Lo creo como rol/especialista heredable de Clemente.

18. **`pangui/partner` actual** (en `~/cristobal/repos/partner/`) lo voy a publicar a GitHub como `pangui/partner` (cuenta personal de CCS) si llego — para que tenga su origen remoto. Si no llego, queda local con git init sin remote como hasta ahora.

19. **TLS en partner.binocular.cl**: Let's Encrypt vía Caddy o Certbot+Nginx. Voy con Caddy por simplicidad (TLS automático + reverse proxy).

20. **Una sola URL pública** (`partner.binocular.cl`) para v0. Cualquier subruta `/<slug>` apunta al webchat del partner correspondiente. La raíz `/` redirige a una landing simple o muestra "este link no es para ti".

## Cómo revisar mañana

Cada ítem está numerado. Para corregir, dime "asunción 7 cambia a X" y aplico.

Lista de control rápida:
- [ ] 1. Nombre Cleme OK?
- [ ] 2. Hash branch / slug OK?
- [ ] 3. Rename binocular/partner → binocular/whispers OK?
- [ ] 4. Repo binocular/partners OK?
- [ ] 5. workspace_id pendiente.
- [ ] 6. Estrategia de modelos OK?
- [ ] 7. Cap $20 OK / sobró / consumido?
- [ ] 8. Gmail scopes mínimos OK?
- [ ] 9. pangui/partner local OK?
- [ ] 10. Sin email match en form OK?
- [ ] 11. Sin PIN OK?
- [ ] 12. Recursión postergada OK?
- [ ] 13. Aprobación single-tier OK?
- [ ] 14-15. Plantilla heredable OK?
- [ ] 16. partner_name cambiable en primer chat OK?
- [ ] 17. Rol niño heredado OK?
- [ ] 18. Push de pangui/partner a GitHub OK?
- [ ] 19. Caddy/TLS OK?
- [ ] 20. Una URL pública OK?
