<template>
  <div>
    <h1>문제 출제의 기본 단계</h1>
    <br>
    <Steps :current="5" :style="{ color: 'black'}">
      <Step title="Algorithmic design" content="Think about the type of algorithm that the problem solver wants to use." status="process"></Step>
      <Step title="surface design" content="Adding appropriate background descriptions to algorithms" status="process"></Step>
      <Step title="input/output format" content="In general, I/O should be kept simple." status="process"></Step>
      <Step title="Creating test data" content="Get as much data as you can, and it's recommended that you write your own code." status="process"></Step>
      <Step title="Test Topic" content="Be sure to write your own code to test if you can get through!!!If necessary, ask someone else to test the subject." icon="ios-star" status="process"></Step>
    </Steps>
    <br>
    <oj-problem-edit
      :problem="problem"
    />
    <Button type="primary" size="large" @click="submit">Submit</Button>
  </div>
</template>
<script>
import ProblemEdit from '@/components/ProblemEdit'
import { mapActions } from 'vuex'

export default {
  components: {
    'oj-problem-edit': ProblemEdit
  },
  data: () => ({
    problem: {
      title: '',
      memory: 32268,
      time: 1000,
      description: '',
      input: '',
      output: '',
      hint: '',
      in: '',
      out: ''
    }
  }),
  methods: {
    ...mapActions('problem', [ 'create' ]),
    submit () {
      if (!this.problem.title.trim()) {
        this.$Message.error('Title can not be empty')
      } else if (!this.problem.description.trim()) {
        this.$Message.error('Description can not be empty')
      } else {
        this
          .create(this.problem)
          .then((pid) => {
            this.$Message.success(`Problem "${this.problem.title}" has been created!`)
            this.$router.push({ name: 'problemInfo', params: { pid } })
          })
      }
    }
  }
}
</script>
<style>
</style>
