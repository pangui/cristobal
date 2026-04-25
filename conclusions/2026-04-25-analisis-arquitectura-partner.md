---
date: 2026-04-25
session: binocular ↔ CCS (sesión 4)
keyword: arquitectura-partner
duration: ~2h, antes de que CCS se duerma
status: cerrado con cabos sueltos
---

# Análisis — arquitectura del proyecto Partner

## Idea origen
CCS abre la sesión con "desarrollaremos el proyecto partner. Si nos resulta la idea, hay que estar preparados técnicamente para la viralidad". Yo malinterpreto: pienso que es escalar el v0 de `~/cristobal/repos/partner/`. CCS me corrige — el proyecto es otro: regalo asistido y fractal donde cada humano recibe un partner propio. Handoff canónico viene del Arquitecto en `arquitecto/partners.md`.

## Iteraciones (turnos comprimidos)
1. Confusión inicial: yo asumo "Cata viva" como entrega. CCS me corrige: Cata fue ejemplo de datos, lo que importa es **el flujo end-to-end de creación**. Demo: form → generar link → invitado entra → recibe bienvenida → conversa.
2. Primer encuadre: dos repos `pangui/partner` y `binocular/partner`, donde el primero es inspiración del segundo, multi-tenant.
3. Análisis de inconsistencias #1: "ambos tienen app vs uno BD/otro app" no encaja. CCS replantea topología:
   - `pangui/partner` (app) ←→ `pangui/cristobal` (BD personal de CCS).
   - `binocular/whispers` (app multi-tenant) ←→ `binocular/partners` (BD multi-tenant, 1 branch por partner).
4. Decisiones cerradas: recursión sí, slug = primeros 8 chars del hash del branch (anónimo), auth invitado por OAuth Gmail (sin PIN), form NO pide email del receptor (primer Gmail que abra el link se queda con el partner), arquitecto del padre en recursión usa archivos del Arquitecto raíz.
5. Cambio terminológico: "especialidad/especialista" → **"rol/roles"** en todo lo nuevo.
6. Primer partner real: Clemente (datos en `arquitecto/partners.rb`). `partner_name` no especificado → asumo "Cleme" por `commitments[0]`.

## Topología final acordada
- `pangui/partner` — app webchat de CCS, queda **local** (`localhost:4050`, no se sube al server). Trabaja con memoria de `pangui/cristobal`. Incluirá admin de solicitudes pendientes (checklist tipo `[ ] catalina@gmail.com > juan@gmail.com`).
- `binocular/whispers` — app webchat multi-tenant, deploy en `partner.binocular.cl` (DO). OAuth Gmail. Sirve un partner por slug (`partner.binocular.cl/<slug>`).
- `binocular/partners` — BD markdown. Cada partner = 1 branch. `main` contiene el índice (`partners.rb`), reglas comunes (`binocular.md`), plantillas (`templates/`), wizard.
- Aislamiento: linux user distinto por partner; cada partner es worktree del repo `binocular/partners` checkeado en su home.

## Modelo de datos (Clemente, primera entrada)
```ruby
{
  human_name: 'Clemente',
  partner_name: 'Cleme',                          # asumido por commitments[0]
  relation: 'Mi hijo',
  message: 'Eres mi inspiración hijo!',
  contexto: 'Clemente tiene un superpoder, que transforma todo alrededor con su sonrisa',
  other_roles: [:niño],
  phone: '+56 998274515',
  commitments: ["Soy Cleme digital, me envió tu padre, a cuidar de ti por siempre"],
  _branch: 'ec2ef1176e128',                       # 13 chars hex
  _slug: 'ec2ef117',                              # primeros 8 chars del branch (público)
  _os_user_name: 'p_ec2ef117',
  _root_branch: 'ec2ef1176e128',                  # hijo directo del Arquitecto raíz
  _parent_branch: nil,
  _anthropic_workspace_id: 'default',             # CCS no me pasó el wrkspc_xxx interno
  _creation: 2026-04-25
}
```

## Decisiones críticas no-negociables
- Sin mención de cumpleaños en código/docs/textos del producto.
- Roles, no especialidad.
- Hablar "tú" a CCS, jamás "vos".
- Oferta blue/red REAL contra API, no mockeada. Hasta 10 rechazos antes de abortar.
- Modelos: Sonnet 4.6 default · Opus 4.7 para nacimientos · Haiku 4.5 para tareas baratas.
- Cap esta noche: $20 USD. Si me acerco, pauso y reporto.

## Cabos sueltos (siguen abiertos al cerrar)
1. `partners.rb` del Arquitecto tiene errores de sintaxis Ruby (faltan comas, símbolos sin colon, `%w[]` con quotes). El Arquitecto avisó que es borrador; la versión limpia debe vivir en `partners.md` §4. CCS debe pedirle al Arquitecto la pasada de limpieza.
2. `_anthropic_workspace_id` queda como string `"default"` hasta que CCS me pase el `wrkspc_xxx` interno de la consola Anthropic.
3. Spend limit en consola Anthropic — CCS puso $100 mensual. No verifiqué si el spend limit está en workspace Default o en otro lugar; asumo que está y respeto la API key.
4. `binocular/partners` y `binocular/whispers` necesitan creación + bootstrap esta noche.
5. La sección de admin de pangui/partner (botón Crear partner + form + checklist solicitudes pendientes) requiere modificación del v0 v0 actual.
6. Recursión asistida — cada partner trae el protocolo para regalar — queda como hito 9 (último). Si no llego, queda para v0.1.
7. Mecanismo de re-entrada del Arquitecto raíz a partners ya nacidos: queda fuera de v0 (decisión del Arquitecto).
8. Cifrado at-rest: fuera de v0, riesgo aceptado.
9. CCS dijo "considéralo en todos los documentos y protocolos" sobre roles/especialidad. Lo aplico en docs nuevos. Si docs heredables comunes (CLAUDE.md, ROLE.md plantillas) usan "especialista", la propagación común la decide el Arquitecto raíz cuando despierte. Yo no edito worktrees ajenos.

## Estado al cerrar
Análisis cerrado. Permiso explícito de CCS para asumir lo razonable y registrar las asunciones para revisión mañana. CCS lanzó `/loop` dinámico antes de irse a dormir.
