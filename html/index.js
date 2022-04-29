const App = Vue.createApp({
    data() {
      return {
        jobs: [
            //{name:"ambulance", label:"Mentő", text:"asdasadasdasddasdasd"},
        ],

        search : ""
      }
    },
    computed: {
        filteredList() {
            if (this.search == "") return this.jobs;

            const lowsearch = this.search.toLowerCase()

            return this.jobs.filter((job) => {
                return job.label.toLowerCase().includes(lowsearch) || job.text.toLowerCase().includes(lowsearch);
            });
        }
    },
    methods: {
        close() {
            fetch(`https://${GetParentResourceName()}/exit`);
        },
        setjob(job) {
            fetch(`https://${GetParentResourceName()}/setjob`, {
                method: 'POST',
                body: JSON.stringify({
                    job: job
                })
            });
        }
    }, 
    mounted() {
        var _this = this;
        window.addEventListener('message', function(event) {
            if (event.data.type == "show") {
                document.body.style.display = event.data.enable ? "block" : "none";
            } else if (event.data.type == "setjobs") {
                _this.jobs = event.data.jobs;
            }
        });
    }
}).mount('#app');