<template>
  <div>
    <!-- <pre>{{ jobs }} </pre> -->
    <!-- 这个注释故意留着，有时候偶用于调试蛮方便的 -->
    <h1>주의사항</h1>
    <br>
    <Steps :current="5" :style="{ color: 'black'}">
      <Step title="난이도 구분" content="정상적인 경우에는 거의 모든 사람이 다 할 수 있는 제목이 한두 개씩 나와야 돼요." status="process"></Step>
      <Step title="정확성" content="테스트하지 않은 문제를 가지고 경기에 들어가지 마라." icon="ios-star" status="process"></Step>
    </Steps>
    <br>
    <oj-contest-edit :contest="contest"></oj-contest-edit>
    <Button type="primary" size="large" @click="submit">Submit</Button>
  </div>
</template>
<script>
import ContestEdit from '@/components/ContestEdit'
import { mapGetters } from 'vuex'

export default {
  data () {
    return {
      contest: {
        title: '',
        start: '',
        end: '',
        list: [],
        encrypt: '',
        argument: ''
      }
    }
  },
  computed: {
    ...mapGetters({
      encrypt: 'encrypt'
    })
  },
  created () {
    this.contest.encrypt = this.encrypt.Public
  },
  methods: {
    submit () {
      if (!this.contest.title) {
        this.$Message.error('Title can not be empty')
      } else if (!this.contest.start || !this.contest.end) {
        this.$Message.error('Time can not be empty')
      } else {
        this.$store.dispatch('contest/create', this.contest)
          .then((cid) => {
            this.$Message.success(`Contest "${this.contest.title}" has been created!`)
            this.$router.push({ name: 'contestOverview', params: { cid } })
          })
      }
    }
  },
  components: {
    'oj-contest-edit': ContestEdit
  }
}
</script>
<style lang="stylus" scoped>
</style>
