# CKA Practice Labs

Ready-made environments for the IT Kiddie CKA practice scenarios. Clone this repository in the Killercoda Kubernetes playground and run one command. The scenario is set up and you can solve the question from the video.

▶️ **Video solutions for every question:** [Practice Questions CKA EXAM 2026 (YouTube playlist)](https://www.youtube.com/playlist?list=PLkDZsCgo3Isr4NB5cmyqG7OZwYEx5XOjM)

## Quick start

1. Open the Kubernetes playground: <https://killercoda.com/playgrounds/scenario/kubernetes>
2. Download the labs:

   ```bash
   git clone https://github.com/ITKiddie/cka-practice-labs.git
   cd cka-practice-labs
   ```

3. Prepare a scenario. For example, scenario 2:

   ```bash
   ./cka.sh setup 2
   ```

4. Solve the question shown in the [video](https://www.youtube.com/playlist?list=PLkDZsCgo3Isr4NB5cmyqG7OZwYEx5XOjM).

When new scenarios are added, run `git pull` inside the `cka-practice-labs` folder to get them.

## Commands

| Command | What it does |
|---|---|
| `./cka.sh list` | Lists the scenarios. |
| `./cka.sh setup <n>` | Prepares scenario `n`. Running it again resets the scenario to its starting point. |
| `./cka.sh cleanup <n>` | Deletes what scenario `n` created. |
| `./cka.sh setup all` | Prepares every scenario at once, except 4 and 14. |

## Scenarios

| # | Scenario | What `setup` creates |
|---|---|---|
| 1 | ArgoCD | Nothing. Solve it directly from the video. |
| 2 | SideCar | Deployment and Service `wordpress` in `default`. |
| 3 | Gateway API | Gateway API CRDs v1.1.0. In namespace `web-app`: `web-deployment`, `web-service`, TLS secret `web-tls` and Ingress `web`. GatewayClass `nginx-class`. |
| 4 | Resource Request | Deployment `wordpress` (3 replicas, with an init container) in `default`. |
| 5 | Storage Class | Nothing. Solve it directly from the video. |
| 6 | PriorityClass | Namespace `priority`, PriorityClass `high-priority` and Deployment `busybox-logger`. |
| 7 | Ingress | Namespace `echo-sound` and Deployment `echoserver-deployment`. |
| 8 | CRDs | cert-manager CRDs v1.14.0. |
| 9 | Network Policy | Namespaces `frontend` and `backend`, one Deployment in each, and Service `backend-service`. |
| 10 | HPA | Namespace `autoscale`, Deployment `apache-deployment` and its Service. |
| 11 | CNI | Nothing. Solve it directly from the video. |
| 12 | PVC | Namespace `mariadb`, PersistentVolume `pv-mariadb` and the file `~/mariadb-deploy.yaml`, which is **not** applied. |
| 13 | CRI-dockerd | Nothing. Solve it directly from the video. |
| 14 | BONUS: Hardest CKA Question (Troubleshoot) | Breaks the control plane on purpose. See below. |
| 15 | Scheduling | Nothing. Solve it directly from the video. |
| 16 | Node Port | Namespace `relative` and Deployment `nodeport-deployment` (2 replicas). |
| 17 | TLS | Namespace `nginx-static`, TLS secret `nginx-tls`, ConfigMap `nginx-config`, Deployment and Service `nginx-static` on port 443. Leaves `~/tls.crt` and `~/tls.key` in your home directory. |

## Good to know

- **Scenario 14 breaks the cluster.** It edits the kube-scheduler, kube-apiserver and kube-controller-manager manifests in `/etc/kubernetes/manifests` and stops the kubelet, so `kubectl` stops working until you fix it. Run it on the `controlplane` node, and leave it for last. To put the cluster back without solving it, run `./cka.sh cleanup 14`.
- **Scenarios 2 and 4 share the `wordpress` Deployment** in `default`. Setting up one of them replaces the other.
- **Scenario 12:** do not apply `~/mariadb-deploy.yaml` during setup. You use it when you solve the scenario.
- The first time, the pods can take a minute or two to start while the images download. `setup` waits for them and warns you if they are not ready yet.
- If the playground gets into a bad state, the quickest fix is to start a new Killercoda playground and clone the repository again.

## Doing the steps by hand

Each folder in [`scenarios/`](scenarios) contains the YAML files from the guide and a `setup.sh` that runs the steps in order, with a comment for each step of the guide. You can read the script, copy the commands, or apply the YAML files yourself.

## En español

1. Abre el playground de Kubernetes: <https://killercoda.com/playgrounds/scenario/kubernetes>
2. Descarga los laboratorios:

   ```bash
   git clone https://github.com/ITKiddie/cka-practice-labs.git
   cd cka-practice-labs
   ```

3. Prepara un escenario, por ejemplo el 2: `./cka.sh setup 2`
4. Resuelve la pregunta del vídeo. Todas las soluciones están en la playlist: <https://www.youtube.com/playlist?list=PLkDZsCgo3Isr4NB5cmyqG7OZwYEx5XOjM>

- `./cka.sh list` muestra todos los escenarios.
- Volver a ejecutar `./cka.sh setup <n>` deja el escenario como al principio. `./cka.sh cleanup <n>` lo borra.
- El escenario 14 rompe el clúster a propósito. Déjalo para el final, o restaura el clúster con `./cka.sh cleanup 14`.
- Para descargar escenarios nuevos, ejecuta `git pull` dentro de la carpeta `cka-practice-labs`.

---

Material by IT Kiddie.
