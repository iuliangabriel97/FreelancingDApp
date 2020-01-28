<template>
  <div>
    <b-container fluid>
      <b-row class="my-1">
        <b-col sm="2">
          <label for="evaluatorAddress">Evaluator address:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input
            id="evaluatorAddress"
            placeholder="Enter evaluator address"
            v-model="evaluatorAddress"
          ></b-form-input>
        </b-col>
      </b-row>

      <b-row class="my-1">
        <b-col sm="2">
          <label for="title">Task title:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input id="title" placeholder="Enter task title" v-model="taskTitle"></b-form-input>
        </b-col>
      </b-row>

      <b-row class="my-1">
        <b-col sm="2">
          <label for="description">Task description:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input
            id="description"
            placeholder="Enter task description"
            v-model="taskDescription"
          ></b-form-input>
        </b-col>
      </b-row>

      <b-row class="my-1">
        <b-col sm="2">
          <label for="domain">Task domain:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input id="domain" placeholder="Enter task domain" v-model="taskDomain"></b-form-input>
        </b-col>
      </b-row>

      <b-row class="my-1">
        <b-col sm="2">
          <label for="estResolveTime">Estimated resolve time:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input
            id="estResolveTime"
            placeholder="Enter estimated resolve time"
            type="date"
            v-model="estResolveTime"
          ></b-form-input>
        </b-col>
      </b-row>

      <b-row class="my-1">
        <b-col sm="2">
          <label for="freelancerPay">Freelancer pay:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input
            id="freelancerPay"
            placeholder="Enter freelancer pay"
            v-model="freelancerPay"
          ></b-form-input>
        </b-col>
      </b-row>

      <b-row class="my-1">
        <b-col sm="2">
          <label for="evaluatorPay">Evaluator pay:</label>
        </b-col>
        <b-col sm="10">
          <b-form-input id="evaluatorPay" placeholder="Enter evaluator pay" v-model="evaluatorPay"></b-form-input>
        </b-col>
      </b-row>
      <b-button variant="success" v-on:click="logInputData">Create task</b-button>
    </b-container>
  </div>
</template>
<script>
import CreateTask from "@/components/create-task";
import { mapState } from "vuex";
export default {
  name: "Manager",
  data: {
    evaluatorAddress: "",
    taskTitle: "",
    taskDescription: "",
    taskDomain: "",
    freelancerPay: "",
    evaluatorPay: "",
    estResolveTime: null
  },
  beforeCreate() {
    console.log("registerWeb3 Action dispatched from dapp.vue");
    this.$store.dispatch("registerWeb3");
  },
  mounted() {
    console.log("dispatching getContractInstance");
    this.$store.dispatch("getContractInstance");
    console.log("dipactching getTokenContractInstance");
    this.$store.dispatch("getTokenContractInstance");
    evaluatorAddress = "";
    console.log("evaluatorAddress:" + evaluatorAddress);
  },
  components: { "create-task": CreateTask },
  methods: {
    logInputData: function(even) {
      console.log(
        this.evaluatorAddress,
        this.taskTitle,
        this.taskDescription,
        this.taskDomain,
        this.evaluatorPay,
        this.freelancerPay,
        this.estResolveTime
      );
    }
  }
};
</script>
<style scoped>
</style>

